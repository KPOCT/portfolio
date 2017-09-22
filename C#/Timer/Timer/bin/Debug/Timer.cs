using System.Linq;

namespace Timer
{
    public partial class Timer : System.Windows.Forms.Form
    {
        enum eAction
        {
            SleepPC = 1,
            TurnOffPC,
            SwitchUser,
            RestartPC,
            KillProcess,
            KillApp
        }

        eAction SelectedIndex;

        int iTotalTime, iTimeLeft, iTime = 0;

        int WM_SYSCOMMAND = 0x0112;
        int SC_MONITORPOWER = 0xF170;

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);

        public Timer( )
        {
            InitializeComponent();
            Tray.Visible = true;
            ActionCB.SelectedIndex = 0;
            WhenCB.SelectedIndex = 1;
            CancelTimerButton.Enabled = false;
            RunAfterTimeLabel.Text = "";
            if (System.DateTime.Now.Hour < 10)
            {
                CurrentTimeLabel.Text = "0" + System.DateTime.Now.ToLongTimeString();
            }
            else
            {
                CurrentTimeLabel.Text = System.DateTime.Now.ToLongTimeString();
            }
        }

        private void Hours_MouseWheel(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (e.Delta > 0)
            {

            }
            else
            {

            }
        }

        private void Minutes_MouseWheel(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (e.Delta > 0)
            {

            }
            else
            {

            }
        }

        private void Seconds_MouseWheel(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (e.Delta > 0)
            {

            }
            else
            {

            }
        }

        private void Hours_ValueChanged(object sender, System.EventArgs e)
        {
            if (Hours.Value == 24)
            {
                Hours.Value = 0;
            }
            else if (Hours.Value == -1)
            {
                Hours.Value = 23;
            }
            if (Hours.Value > -1 && Hours.Value < 0)
            {
                Hours.Value = 0;
            }
        }

        private void Minutes_ValueChanged(object sender, System.EventArgs e)
        {
            if (Minutes.Value == 60)
            {
                Hours.Value++;
                Minutes.Value = 0;
            }
            if (Minutes.Value == -1)
            {
                Hours.Value--;
                Minutes.Value = 59;
            }
            if (Minutes.Value > -1 && Minutes.Value < 0)
            {
                Minutes.Value = 0;
            }
        }

        private void Seconds_ValueChanged(object sender, System.EventArgs e)
        {
            if (Seconds.Value == 60)
            {
                Minutes.Value++;
                Seconds.Value = 0;
            }
            if (Seconds.Value == -1)
            {
                Minutes.Value--;
                Seconds.Value = 59;
            }
            if (Seconds.Value == -1 && Minutes.Value == 0)
            {
                Seconds.Value = 0;
            }
        }

        private void Timer4UpdCurTime_Tick(object sender, System.EventArgs e)
        {
            if (System.DateTime.Now.Hour < 10)
            {
                CurrentTimeLabel.Text = "0" + System.DateTime.Now.ToLongTimeString();
            }
            else
            {
                CurrentTimeLabel.Text = System.DateTime.Now.ToLongTimeString();
            }
        }

        private void Timer4RunAction_Tick( object sender, System.EventArgs e )
        {
            iTime++;
            iTimeLeft = iTotalTime - iTime;

            System.TimeSpan tsTimeLeft = new System.TimeSpan( 0, 0, iTimeLeft );
            Tray.Text = "Выполнится через " + tsTimeLeft.ToString( );
            RunAfterTimeLabel.Text = "       Выполнится через                        " + tsTimeLeft.ToString();

            if( iTime == iTotalTime )
            {
                CancelTimerButton_Click( sender, e );

                iTime = 0;

                switch ( SelectedIndex )
                {
                    case eAction.SleepPC:
                        System.Diagnostics.Process.Start
                        (
                            new System.Diagnostics.ProcessStartInfo( "cmd", @"/c rundll32.exe PowrProf.dll,SetSuspendState" )
                        );
                        System.Diagnostics.Process.Start
                        (
                            new System.Diagnostics.ProcessStartInfo( "cmd", @"/c shutdown -h" )
                        );
                        Close( );
                        break;
                    case eAction.TurnOffPC:
                        System.Diagnostics.Process.Start
                        (
                            new System.Diagnostics.ProcessStartInfo( "cmd", @"/c shutdown -s" )
                        );
                        break;
                    case eAction.SwitchUser:
                        System.Diagnostics.Process.Start
                        (
                            new System.Diagnostics.ProcessStartInfo( "cmd", @"/c shutdown -l" )
                        );
                        Close( );
                        break;
                    case eAction.RestartPC:
                        System.Diagnostics.Process.Start
                        (
                            new System.Diagnostics.ProcessStartInfo( "cmd", @"/c shutdown -r" )
                        );
                        break;
                    case eAction.KillProcess:
                        foreach( System.Diagnostics.Process currentProcess in System.Diagnostics.Process.GetProcessesByName( ProcessesCB.Text ) )
                        {
                            currentProcess.Kill( );
                            Close( );
                        }
                        break;
                    case eAction.KillApp:
                        foreach( System.Diagnostics.Process currentProcess in System.Diagnostics.Process.GetProcessesByName( ProcessesCB.Text ) )
                        {
                            SendMessage( this.Handle.ToInt32( ), WM_SYSCOMMAND, SC_MONITORPOWER, 2 ); // Turn off the monitor
                            currentProcess.Kill( );
                            Close( );
                        }
                        break;
                }
            }
            else if ( iTimeLeft <= 600 )
            {
                if( ( iTimeLeft / 60 >= 1 && iTimeLeft / 60 <= 10 ) || ( iTimeLeft >= 1 && iTimeLeft <= 10 ) )
                {
                    Tray.ShowBalloonTip( 10000, "Таймер", "Выполнится через " + tsTimeLeft.ToString(), System.Windows.Forms.ToolTipIcon.Error );
                }
            }
        }

        private void StartTimer_Click(object sender, System.EventArgs e)
        {
            if (Timer4RunAction.Enabled == false)
            {
                int HTime, MTime, STime;
                if (WhenCB.SelectedIndex == 0)
                {
                    HTime = (int)Hours.Value * 3600;
                    MTime = (int)Minutes.Value * 60;
                    STime = (int)Seconds.Value;
                    iTotalTime = HTime + MTime + STime;
                }
                else if (WhenCB.SelectedIndex == 1)
                {
                    if ((int)Hours.Value == 0 && (int)Minutes.Value == 0 && (int)Seconds.Value == 0)
                    {
                        HTime = ((int)Hours.Value + 24 - System.DateTime.Now.Hour) * 3600;
                    }
                    else if ((int)Hours.Value < System.DateTime.Now.Hour)
                    {
                        HTime = ((int)Hours.Value + 24 - System.DateTime.Now.Hour) * 3600;
                    }
                    else if ((int)Hours.Value == System.DateTime.Now.Hour)
                    {
                        if ((int)Minutes.Value < System.DateTime.Now.Minute)
                        {
                            HTime = ((int)Hours.Value + 24 - System.DateTime.Now.Hour) * 3600;
                        }
                        else if ((int)Minutes.Value == System.DateTime.Now.Minute)
                        {
                            if ((int)Seconds.Value < System.DateTime.Now.Second)
                            {
                                HTime = ((int)Hours.Value + 24 - System.DateTime.Now.Hour) * 3600;
                            }
                            else
                            {
                                HTime = ((int)Hours.Value - System.DateTime.Now.Hour) * 3600;
                            }
                        }
                        else
                        {
                            HTime = ((int)Hours.Value - System.DateTime.Now.Hour) * 3600;
                        }
                    }
                    else
                    {
                        HTime = ((int)Hours.Value - System.DateTime.Now.Hour) * 3600;
                    }
                    MTime = ((int)Minutes.Value - System.DateTime.Now.Minute) * 60;
                    STime = (int)Seconds.Value - System.DateTime.Now.Second;
                    iTotalTime = HTime + MTime + STime;
                }
                Timer4RunAction.Enabled = true;
                Hours.Enabled = false;
                Minutes.Enabled = false;
                Seconds.Enabled = false;
                ActionCB.Enabled = false;
                WhenCB.Enabled = false;
                ProcessesCB.Enabled = false;
                StartTimerButton.Enabled = false;
                StartTimerButton.Size = new System.Drawing.Size(0, 0);
                CancelTimerButton.Enabled = true;
                System.TimeSpan TS = new System.TimeSpan(0, 0, iTotalTime);
                WindowState = System.Windows.Forms.FormWindowState.Minimized;
                ShowInTaskbar = false;
                Tray.ShowBalloonTip(2000, "Таймер", "Таймер запущен. Выполнится через " + TS.ToString(), System.Windows.Forms.ToolTipIcon.Info);
            }
        }

        private void CancelTimerButton_Click(object sender, System.EventArgs e)
        {
            StartTimerButton.Enabled = true;
            StartTimerButton.Size = new System.Drawing.Size(181, 36);
            Timer4RunAction.Enabled = false;
            iTime = 0;
            Hours.Enabled = true;
            Minutes.Enabled = true;
            Seconds.Enabled = true;
            ActionCB.Enabled = true;
            WhenCB.Enabled = true;
            ProcessesCB.Enabled = true;
            CancelTimerButton.Enabled = false;
            ActionCB.SelectedIndex = ActionCB.SelectedIndex;
            if (WhenCB.SelectedIndex == 0)
            {
                Hours.Value = 1;
                Minutes.Value = 0;
                Seconds.Value = 0;
            }
            else if (WhenCB.SelectedIndex == 1)
            {
                Hours.Value = System.DateTime.Now.Hour;
                Seconds.Value = 0;
                for (int i = 30; i <= 60; i += 30)
                {
                    if (System.DateTime.Now.Minute >= i - 30 && System.DateTime.Now.Minute < i)
                    {
                        if ((i - System.DateTime.Now.Minute) > 10)
                        {
                            Minutes.Value = i;
                            if (System.DateTime.Now.Hour != 23)
                            {
                                Hours.Value++;
                            }
                            else
                            {
                                Hours.Value = 0;
                            }
                            break;
                        }
                        else
                        {
                            Minutes.Value = i - 30;
                            for (int j = 0; j < 2; j++)
                            {
                                if (System.DateTime.Now.Hour != 23)
                                {
                                    Hours.Value++;
                                }
                                else
                                {
                                    Hours.Value = 0;
                                }
                            }
                            break;
                        }
                    }
                }
            }
            Tray.ShowBalloonTip(2000, "Таймер", "Таймер выключен.", System.Windows.Forms.ToolTipIcon.Info);
            Tray.Text = "Таймер выключен.";
        }

        private void ProcessesCB_Click(object sender, System.EventArgs e)
        {
            FillProcessesCB( );
        }

        private void ActionCB_SelectedIndexChanged( object sender, System.EventArgs e )
        {
            ProcessesCB.TabStop = false;
            SelectedIndex = ( eAction ) ( ActionCB.SelectedIndex + 1 );
            //
            // Перемещение
            //
            if ( SelectedIndex == eAction.KillApp || SelectedIndex == eAction.KillProcess )
            {
                FillProcessesCB();
                ProcessesCB.TabStop = true;

                ProcessesCB.Size = new System.Drawing.Size(180, 26);
                ActionCB.Location = new System.Drawing.Point(4, 6);
                WhenCB.Location = new System.Drawing.Point(4, 34);
                HLabel.Location = new System.Drawing.Point(188, 70);
                MLabel.Location = new System.Drawing.Point(244, 70);
                SLabel.Location = new System.Drawing.Point(300, 70);
                Hours.Location = new System.Drawing.Point(192, 48);
                Minutes.Location = new System.Drawing.Point(248, 48);
                Seconds.Location = new System.Drawing.Point(304, 48);
                CurrentTimeLabel.Location = new System.Drawing.Point(188, 2);
            }
            else
            {
                ProcessesCB.Size = new System.Drawing.Size(0, 0);
                HLabel.Location = new System.Drawing.Point(188, 74);
                MLabel.Location = new System.Drawing.Point(244, 74);
                SLabel.Location = new System.Drawing.Point(300, 74);
                Hours.Location = new System.Drawing.Point(192, 52);
                Minutes.Location = new System.Drawing.Point(248, 52);
                Seconds.Location = new System.Drawing.Point(304, 52);
                ActionCB.Location = new System.Drawing.Point(6, 14);
                WhenCB.Location = new System.Drawing.Point(6, 54);
                CurrentTimeLabel.Location = new System.Drawing.Point(188, 6);
            }
        }

        private void WhenCB_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            if (WhenCB.SelectedItem.ToString() == "Спустя указанное время")
            {
                Hours.Value = 1;
                Minutes.Value = 0;
                Seconds.Value = 0;
            }
            else if (WhenCB.SelectedItem.ToString() == "В указанное время")
            {
                Hours.Value = System.DateTime.Now.Hour;
                Seconds.Value = 0;
                for (int i = 30; i <= 60; i += 30)
                {
                    if (System.DateTime.Now.Minute >= i - 30 && System.DateTime.Now.Minute < i)
                    {
                        if ((i - System.DateTime.Now.Minute) > 10)
                        {
                            Minutes.Value = i;
                            if (System.DateTime.Now.Hour != 23)
                            {
                                Hours.Value++;
                            }
                            else
                            {
                                Hours.Value = 0;
                            }
                            break;
                        }
                        else
                        {
                            Minutes.Value = i - 30;
                            for (int j = 0; j < 2; j++)
                            {
                                if (System.DateTime.Now.Hour != 23)
                                {
                                    Hours.Value++;
                                }
                                else
                                {
                                    Hours.Value = 0;
                                }
                            }
                            break;
                        }
                    }
                }
            }
        }

        private void ActionLabel_Click(object sender, System.EventArgs e)
        {
            ActionCB.DroppedDown = true;
        }

        private void WhenLabel_Click(object sender, System.EventArgs e)
        {
            WhenCB.DroppedDown = true;
        }

        private void Tray_BalloonTipClicked(object sender, System.EventArgs e)
        {
            ShowInTaskbar = true;
            WindowState = System.Windows.Forms.FormWindowState.Normal;
        }

        private void ЗапуститьТаймер_Click(object sender, System.EventArgs e)
        {
            StartTimerButton.PerformClick();
        }

        private void ВыключитьТаймер_Click(object sender, System.EventArgs e)
        {
            CancelTimerButton.PerformClick();
        }

        private void Выйти_Click(object sender, System.EventArgs e)
        {
            Close();
        }

        private void ContextMenuTray_Opening(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if (Timer4RunAction.Enabled)
            {
                ЗапуститьТаймер.Enabled = false;
                ВыключитьТаймер.Enabled = true;
            }
            else
            {
                ЗапуститьТаймер.Enabled = true;
                ВыключитьТаймер.Enabled = false;
            }
        }

        private void Tray_MouseClick(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            if (e.Button == System.Windows.Forms.MouseButtons.Left)
            {
                if (WindowState == System.Windows.Forms.FormWindowState.Minimized)
                {
                    ShowInTaskbar = true;
                    WindowState = System.Windows.Forms.FormWindowState.Normal;
                }
                else
                {
                    ShowInTaskbar = false;
                    WindowState = System.Windows.Forms.FormWindowState.Minimized;
                }
            }
        }
        
        private void Timer_FormClosing(object sender, System.Windows.Forms.FormClosingEventArgs e)
        {
            Tray.Visible = false;
        }

        private void Timer_Minimize( object sender, System.EventArgs e )
        {
            if (WindowState == System.Windows.Forms.FormWindowState.Minimized)
            {
                ShowInTaskbar = false;
            }
        }

        void FillProcessesCB( )
        {
            ProcessesCB.Items.Clear( );

            if( SelectedIndex == eAction.KillProcess )
            {
                foreach( System.Diagnostics.Process Process in System.Diagnostics.Process.GetProcesses( ).Where( Process => Process.ProcessName != "Timer" ) )
                {
                    ProcessesCB.Items.Add( Process.ProcessName );
                }
            }
            else if( SelectedIndex == eAction.KillApp )
            {
                var procList = System.Diagnostics.Process.GetProcesses( )
                    .Where( Process => ( Process.MainWindowHandle != System.IntPtr.Zero ) && ( Process.ProcessName != "explorer" && Process.ProcessName != "Timer" ) );

                foreach( System.Diagnostics.Process Process in procList )
                {
                    if( Process.Handle != System.Diagnostics.Process.GetCurrentProcess( ).MainWindowHandle )
                    {
                        ProcessesCB.Items.Add( Process.ProcessName );
                    }
                }
            }

            ProcessesCB.Sorted = true;
            ProcessesCB.SelectedIndex = 0;
        }
    }
}