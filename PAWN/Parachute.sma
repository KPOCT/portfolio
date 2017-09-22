#include <amxmisc>
#include <engine>
#include <fun>

new bool:has_parachute[33], bool:bOld[33]
new para_ent[33]
new pDetach, pFallSpeed
new Float:fOldGrav = 1.0

public plugin_init()
{
	register_plugin("Parachute", "1.0", "KPOCT")
	pFallSpeed = register_cvar("parachute_fallspeed", "50")
	pDetach = register_cvar("parachute_detach", "1")
	
	register_event("ResetHUD", "newSpawn", "be")
	register_event("DeathMsg", "death_event", "a")
}

public client_connect(id)
{
	parachute_reset(id)
}

public client_disconnect(id)
{
	parachute_reset(id)
}

public death_event()
{
	new id = read_data(2)
	parachute_reset(id)
}

parachute_reset(id)
{
	fOldGrav = 1.0
	if(para_ent[id] > 0) {
		if (is_valid_ent(para_ent[id])) {
			remove_entity(para_ent[id])
		}
	}

	if (is_user_alive(id)) set_user_gravity(id, fOldGrav)

	bOld[id] = true
	has_parachute[id] = false
	para_ent[id] = 0
}

public newSpawn(id)
{
	if(para_ent[id] > 0) {
		remove_entity(para_ent[id])
		fOldGrav = 1.0
		set_user_gravity(id, 1.0)
		bOld[id] = true
		para_ent[id] = 0
	}
	has_parachute[id] = true
}

public plugin_natives()
{
	set_module_filter("module_filter")
	set_native_filter("native_filter")
}

public module_filter(const module[])
{
	if (!cstrike_running() && equali(module, "cstrike")) {
		return PLUGIN_HANDLED
	}

	return PLUGIN_CONTINUE
}

public native_filter(const name[], index, trap)
{
	if (!trap) return PLUGIN_HANDLED

	return PLUGIN_CONTINUE
}

public client_PreThink(id)
{
	//parachute.mdl animation information
	//0 - deploy - 84 frames
	//1 - idle - 39 frames
	//2 - detach - 29 frames

	if (!is_user_alive(id) || !has_parachute[id]) return

	new Float:fallspeed = get_pcvar_float(pFallSpeed) * -1.0
	new Float:frame

	new button = get_user_button(id)
	new oldbutton = get_user_oldbutton(id)
	new flags = get_entity_flags(id)

	if (para_ent[id] > 0 && (flags & FL_ONGROUND)) {

		if (get_pcvar_num(pDetach)) {

			if (get_user_gravity(id) == 0.1) set_user_gravity(id, fOldGrav)

			if (entity_get_int(para_ent[id],EV_INT_sequence) != 2) {
				entity_set_int(para_ent[id], EV_INT_sequence, 2)
				entity_set_int(para_ent[id], EV_INT_gaitsequence, 1)
				entity_set_float(para_ent[id], EV_FL_frame, 0.0)
				entity_set_float(para_ent[id], EV_FL_fuser1, 0.0)
				entity_set_float(para_ent[id], EV_FL_animtime, 0.0)
				entity_set_float(para_ent[id], EV_FL_framerate, 0.0)
				return
			}

			frame = entity_get_float(para_ent[id],EV_FL_fuser1) + 2.0
			entity_set_float(para_ent[id],EV_FL_fuser1,frame)
			entity_set_float(para_ent[id],EV_FL_frame,frame)

			if (frame > 254.0) {
				remove_entity(para_ent[id])
				para_ent[id] = 0
			}
		}
		else {
			remove_entity(para_ent[id])
			set_user_gravity(id, fOldGrav)
			para_ent[id] = 0
		}

		return
	}

	if (button & IN_USE) {
		new Float:velocity[3]
		entity_get_vector(id, EV_VEC_velocity, velocity)

		if (velocity[2] < 0.0) {

			if(para_ent[id] <= 0) {
				para_ent[id] = create_entity("info_target")
				if(para_ent[id] > 0) {
					entity_set_string(para_ent[id],EV_SZ_classname,"parachute")
					entity_set_edict(para_ent[id], EV_ENT_aiment, id)
					entity_set_edict(para_ent[id], EV_ENT_owner, id)
					entity_set_int(para_ent[id], EV_INT_movetype, MOVETYPE_FOLLOW)
					entity_set_int(para_ent[id], EV_INT_sequence, 0)
					entity_set_int(para_ent[id], EV_INT_gaitsequence, 1)
					entity_set_float(para_ent[id], EV_FL_frame, 0.0)
					entity_set_float(para_ent[id], EV_FL_fuser1, 0.0)
				}
			}

			if (para_ent[id] > 0) {

				entity_set_int(id, EV_INT_sequence, 3)
				entity_set_int(id, EV_INT_gaitsequence, 1)
				entity_set_float(id, EV_FL_frame, 1.0)
				entity_set_float(id, EV_FL_framerate, 1.0)
				if (bOld[id])
				{
					fOldGrav = get_user_gravity(id)
					bOld[id] = false
				}
				if(get_user_gravity(id) != 0.1)
				{
					fOldGrav = get_user_gravity(id)
				}
				set_user_gravity(id, 0.1)

				velocity[2] = (velocity[2] + 40.0 < fallspeed) ? velocity[2] + 40.0 : fallspeed
				entity_set_vector(id, EV_VEC_velocity, velocity)

				if (entity_get_int(para_ent[id],EV_INT_sequence) == 0) {

					frame = entity_get_float(para_ent[id],EV_FL_fuser1) + 1.0
					entity_set_float(para_ent[id],EV_FL_fuser1,frame)
					entity_set_float(para_ent[id],EV_FL_frame,frame)

					if (frame > 100.0) {
						entity_set_float(para_ent[id], EV_FL_animtime, 0.0)
						entity_set_float(para_ent[id], EV_FL_framerate, 0.4)
						entity_set_int(para_ent[id], EV_INT_sequence, 1)
						entity_set_int(para_ent[id], EV_INT_gaitsequence, 1)
						entity_set_float(para_ent[id], EV_FL_frame, 0.0)
						entity_set_float(para_ent[id], EV_FL_fuser1, 0.0)
					}
				}
			}
		}
		else if (para_ent[id] > 0) {
			remove_entity(para_ent[id])
			set_user_gravity(id, fOldGrav)
			para_ent[id] = 0
		}
	}
	else if ((oldbutton & IN_USE) && para_ent[id] > 0 ) {
		remove_entity(para_ent[id])
		set_user_gravity(id, fOldGrav)
		bOld[id] = true
		para_ent[id] = 0
	}
}