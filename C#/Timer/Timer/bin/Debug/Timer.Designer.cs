namespace Timer
{
    partial class Timer
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Timer));
            this.HLabel = new System.Windows.Forms.Label();
            this.MLabel = new System.Windows.Forms.Label();
            this.SLabel = new System.Windows.Forms.Label();
            this.Hours = new System.Windows.Forms.NumericUpDown();
            this.Minutes = new System.Windows.Forms.NumericUpDown();
            this.Seconds = new System.Windows.Forms.NumericUpDown();
            this.Timer4UpdCurTime = new System.Windows.Forms.Timer(this.components);
            this.CancelTimerButton = new System.Windows.Forms.Button();
            this.StartTimerButton = new System.Windows.Forms.Button();
            this.ActionCB = new System.Windows.Forms.ComboBox();
            this.WhenCB = new System.Windows.Forms.ComboBox();
            this.CurrentTimeLabel = new System.Windows.Forms.Label();
            this.Tray = new System.Windows.Forms.NotifyIcon(this.components);
            this.ContextMenuTray = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.ЗапуститьТаймер = new System.Windows.Forms.ToolStripMenuItem();
            this.ВыключитьТаймер = new System.Windows.Forms.ToolStripMenuItem();
            this.Сепаратюга = new System.Windows.Forms.ToolStripSeparator();
            this.Выйти = new System.Windows.Forms.ToolStripMenuItem();
            this.Timer4RunAction = new System.Windows.Forms.Timer(this.components);
            this.ProcessesCB = new System.Windows.Forms.ComboBox();
            this.RunAfterTimeLabel = new System.Windows.Forms.Label();
            this.ToolTip = new System.Windows.Forms.ToolTip(this.components);
            this.AboutDevLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.Hours)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.Minutes)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.Seconds)).BeginInit();
            this.ContextMenuTray.SuspendLayout();
            this.SuspendLayout();
            // 
            // HLabel
            // 
            this.HLabel.AutoSize = true;
            this.HLabel.BackColor = System.Drawing.Color.Transparent;
            this.HLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.HLabel.Location = new System.Drawing.Point(188, 74);
            this.HLabel.Name = "HLabel";
            this.HLabel.Size = new System.Drawing.Size(25, 24);
            this.HLabel.TabIndex = 2;
            this.HLabel.Text = "ч.";
            // 
            // MLabel
            // 
            this.MLabel.AutoSize = true;
            this.MLabel.BackColor = System.Drawing.Color.Transparent;
            this.MLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.MLabel.Location = new System.Drawing.Point(244, 74);
            this.MLabel.Name = "MLabel";
            this.MLabel.Size = new System.Drawing.Size(50, 24);
            this.MLabel.TabIndex = 5;
            this.MLabel.Text = "мин.";
            // 
            // SLabel
            // 
            this.SLabel.AutoSize = true;
            this.SLabel.BackColor = System.Drawing.Color.Transparent;
            this.SLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.SLabel.Location = new System.Drawing.Point(300, 74);
            this.SLabel.Name = "SLabel";
            this.SLabel.Size = new System.Drawing.Size(45, 24);
            this.SLabel.TabIndex = 11;
            this.SLabel.Text = "сек.";
            // 
            // Hours
            // 
            this.Hours.BackColor = System.Drawing.Color.DarkSlateGray;
            this.Hours.Font = new System.Drawing.Font("Microsoft Sans Serif", 13F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))));
            this.Hours.ForeColor = System.Drawing.Color.PaleTurquoise;
            this.Hours.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.Hours.Location = new System.Drawing.Point(192, 52);
            this.Hours.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.Hours.Maximum = new decimal(new int[] {
            24,
            0,
            0,
            0});
            this.Hours.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.Hours.Name = "Hours";
            this.Hours.Size = new System.Drawing.Size(50, 27);
            this.Hours.TabIndex = 1;
            this.Hours.Tag = "";
            this.Hours.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.Hours.ThousandsSeparator = true;
            this.Hours.ValueChanged += new System.EventHandler(this.Hours_ValueChanged);
            this.Hours.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.Hours_MouseWheel);
            // 
            // Minutes
            // 
            this.Minutes.BackColor = System.Drawing.Color.DarkSlateGray;
            this.Minutes.Font = new System.Drawing.Font("Microsoft Sans Serif", 13F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))));
            this.Minutes.ForeColor = System.Drawing.Color.PaleTurquoise;
            this.Minutes.Location = new System.Drawing.Point(248, 52);
            this.Minutes.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.Minutes.Maximum = new decimal(new int[] {
            60,
            0,
            0,
            0});
            this.Minutes.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.Minutes.Name = "Minutes";
            this.Minutes.Size = new System.Drawing.Size(50, 27);
            this.Minutes.TabIndex = 2;
            this.Minutes.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.Minutes.ValueChanged += new System.EventHandler(this.Minutes_ValueChanged);
            this.Minutes.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.Minutes_MouseWheel);
            // 
            // Seconds
            // 
            this.Seconds.BackColor = System.Drawing.Color.DarkSlateGray;
            this.Seconds.Font = new System.Drawing.Font("Microsoft Sans Serif", 13F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))));
            this.Seconds.ForeColor = System.Drawing.Color.PaleTurquoise;
            this.Seconds.Location = new System.Drawing.Point(304, 52);
            this.Seconds.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.Seconds.Maximum = new decimal(new int[] {
            60,
            0,
            0,
            0});
            this.Seconds.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.Seconds.Name = "Seconds";
            this.Seconds.Size = new System.Drawing.Size(50, 27);
            this.Seconds.TabIndex = 3;
            this.Seconds.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.Seconds.ValueChanged += new System.EventHandler(this.Seconds_ValueChanged);
            this.Seconds.MouseWheel += new System.Windows.Forms.MouseEventHandler(this.Seconds_MouseWheel);
            // 
            // Timer4UpdCurTime
            // 
            this.Timer4UpdCurTime.Enabled = true;
            this.Timer4UpdCurTime.Interval = 1000;
            this.Timer4UpdCurTime.Tick += new System.EventHandler(this.Timer4UpdCurTime_Tick);
            // 
            // CancelTimerButton
            // 
            this.CancelTimerButton.BackColor = System.Drawing.Color.DarkSlateGray;
            this.CancelTimerButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.CancelTimerButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CancelTimerButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.CancelTimerButton.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.CancelTimerButton.Location = new System.Drawing.Point(4, 94);
            this.CancelTimerButton.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.CancelTimerButton.Name = "CancelTimerButton";
            this.CancelTimerButton.Size = new System.Drawing.Size(163, 36);
            this.CancelTimerButton.TabIndex = 20;
            this.CancelTimerButton.Text = "Отменить таймер";
            this.ToolTip.SetToolTip(this.CancelTimerButton, "Отменить таймер");
            this.CancelTimerButton.UseVisualStyleBackColor = false;
            this.CancelTimerButton.Click += new System.EventHandler(this.CancelTimerButton_Click);
            // 
            // StartTimerButton
            // 
            this.StartTimerButton.BackColor = System.Drawing.Color.DarkSlateGray;
            this.StartTimerButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.StartTimerButton.FlatAppearance.BorderColor = System.Drawing.Color.LightSeaGreen;
            this.StartTimerButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.StartTimerButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.StartTimerButton.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.StartTimerButton.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.StartTimerButton.Location = new System.Drawing.Point(173, 94);
            this.StartTimerButton.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.StartTimerButton.Name = "StartTimerButton";
            this.StartTimerButton.Size = new System.Drawing.Size(181, 36);
            this.StartTimerButton.TabIndex = 23;
            this.StartTimerButton.Text = "Запустить таймер";
            this.ToolTip.SetToolTip(this.StartTimerButton, "Запустить таймер");
            this.StartTimerButton.UseVisualStyleBackColor = false;
            this.StartTimerButton.Click += new System.EventHandler(this.StartTimer_Click);
            // 
            // ActionCB
            // 
            this.ActionCB.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.ActionCB.BackColor = System.Drawing.Color.DarkSlateGray;
            this.ActionCB.Cursor = System.Windows.Forms.Cursors.Hand;
            this.ActionCB.DropDownHeight = 100;
            this.ActionCB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.ActionCB.DropDownWidth = 300;
            this.ActionCB.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.ActionCB.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F);
            this.ActionCB.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.ActionCB.IntegralHeight = false;
            this.ActionCB.Items.AddRange(new object[] {
            "Гибернация (сон)",
            "Завершить работу",
            "Сменить пользователя",
            "Перезагрузка",
            "Завершить процесс",
            "Завершить приложение"});
            this.ActionCB.Location = new System.Drawing.Point(4, 14);
            this.ActionCB.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.ActionCB.MaxDropDownItems = 10;
            this.ActionCB.Name = "ActionCB";
            this.ActionCB.Size = new System.Drawing.Size(180, 26);
            this.ActionCB.TabIndex = 27;
            this.ToolTip.SetToolTip(this.ActionCB, "Выберите действие");
            this.ActionCB.SelectedIndexChanged += new System.EventHandler(this.ActionCB_SelectedIndexChanged);
            // 
            // WhenCB
            // 
            this.WhenCB.AccessibleName = "";
            this.WhenCB.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.WhenCB.BackColor = System.Drawing.Color.DarkSlateGray;
            this.WhenCB.Cursor = System.Windows.Forms.Cursors.Hand;
            this.WhenCB.DropDownHeight = 100;
            this.WhenCB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.WhenCB.DropDownWidth = 300;
            this.WhenCB.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.WhenCB.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F);
            this.WhenCB.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.WhenCB.IntegralHeight = false;
            this.WhenCB.ItemHeight = 18;
            this.WhenCB.Items.AddRange(new object[] {
            "Спустя указанное время",
            "В указанное время"});
            this.WhenCB.Location = new System.Drawing.Point(4, 54);
            this.WhenCB.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.WhenCB.Name = "WhenCB";
            this.WhenCB.Size = new System.Drawing.Size(180, 26);
            this.WhenCB.TabIndex = 28;
            this.ToolTip.SetToolTip(this.WhenCB, "Когда выполнить?");
            this.WhenCB.SelectedIndexChanged += new System.EventHandler(this.WhenCB_SelectedIndexChanged);
            // 
            // CurrentTimeLabel
            // 
            this.CurrentTimeLabel.BackColor = System.Drawing.Color.Transparent;
            this.CurrentTimeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 26F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))));
            this.CurrentTimeLabel.ForeColor = System.Drawing.Color.PaleTurquoise;
            this.CurrentTimeLabel.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.CurrentTimeLabel.Location = new System.Drawing.Point(186, 6);
            this.CurrentTimeLabel.Name = "CurrentTimeLabel";
            this.CurrentTimeLabel.Size = new System.Drawing.Size(176, 45);
            this.CurrentTimeLabel.TabIndex = 22;
            this.CurrentTimeLabel.Text = "CurTime";
            // 
            // Tray
            // 
            this.Tray.BalloonTipIcon = System.Windows.Forms.ToolTipIcon.Info;
            this.Tray.BalloonTipText = "Таймер запущен.";
            this.Tray.ContextMenuStrip = this.ContextMenuTray;
            this.Tray.Icon = ((System.Drawing.Icon)(resources.GetObject("Tray.Icon")));
            this.Tray.Text = "Таймер выключен";
            this.Tray.Visible = true;
            this.Tray.BalloonTipClicked += new System.EventHandler(this.Tray_BalloonTipClicked);
            this.Tray.MouseClick += new System.Windows.Forms.MouseEventHandler(this.Tray_MouseClick);
            // 
            // ContextMenuTray
            // 
            this.ContextMenuTray.BackColor = System.Drawing.Color.DarkSlateGray;
            this.ContextMenuTray.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ЗапуститьТаймер,
            this.ВыключитьТаймер,
            this.Сепаратюга,
            this.Выйти});
            this.ContextMenuTray.Name = "ContextMenuTray";
            this.ContextMenuTray.RenderMode = System.Windows.Forms.ToolStripRenderMode.Professional;
            this.ContextMenuTray.ShowImageMargin = false;
            this.ContextMenuTray.Size = new System.Drawing.Size(179, 76);
            this.ContextMenuTray.Opening += new System.ComponentModel.CancelEventHandler(this.ContextMenuTray_Opening);
            // 
            // ЗапуститьТаймер
            // 
            this.ЗапуститьТаймер.BackColor = System.Drawing.Color.DarkSlateGray;
            this.ЗапуститьТаймер.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.ЗапуститьТаймер.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold);
            this.ЗапуститьТаймер.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.ЗапуститьТаймер.ImageTransparentColor = System.Drawing.Color.DarkSlateGray;
            this.ЗапуститьТаймер.Name = "ЗапуститьТаймер";
            this.ЗапуститьТаймер.Size = new System.Drawing.Size(178, 22);
            this.ЗапуститьТаймер.Text = "Запустить Таймер";
            this.ЗапуститьТаймер.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.ЗапуститьТаймер.Click += new System.EventHandler(this.ЗапуститьТаймер_Click);
            // 
            // ВыключитьТаймер
            // 
            this.ВыключитьТаймер.BackColor = System.Drawing.Color.DarkSlateGray;
            this.ВыключитьТаймер.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.ВыключитьТаймер.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold);
            this.ВыключитьТаймер.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.ВыключитьТаймер.ImageTransparentColor = System.Drawing.Color.DarkSlateGray;
            this.ВыключитьТаймер.Name = "ВыключитьТаймер";
            this.ВыключитьТаймер.Size = new System.Drawing.Size(178, 22);
            this.ВыключитьТаймер.Text = "Выключить таймер";
            this.ВыключитьТаймер.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.ВыключитьТаймер.Click += new System.EventHandler(this.ВыключитьТаймер_Click);
            // 
            // Сепаратюга
            // 
            this.Сепаратюга.BackColor = System.Drawing.Color.LightSeaGreen;
            this.Сепаратюга.ForeColor = System.Drawing.Color.PaleTurquoise;
            this.Сепаратюга.Name = "Сепаратюга";
            this.Сепаратюга.Size = new System.Drawing.Size(175, 6);
            // 
            // Выйти
            // 
            this.Выйти.BackColor = System.Drawing.Color.DarkSlateGray;
            this.Выйти.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.Выйти.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold);
            this.Выйти.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.Выйти.ImageTransparentColor = System.Drawing.Color.DarkSlateGray;
            this.Выйти.Name = "Выйти";
            this.Выйти.Size = new System.Drawing.Size(178, 22);
            this.Выйти.Text = "Выйти";
            this.Выйти.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.Выйти.Click += new System.EventHandler(this.Выйти_Click);
            // 
            // Timer4RunAction
            // 
            this.Timer4RunAction.Interval = 1000;
            this.Timer4RunAction.Tick += new System.EventHandler(this.Timer4RunAction_Tick);
            // 
            // ProcessesCB
            // 
            this.ProcessesCB.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.ProcessesCB.BackColor = System.Drawing.Color.DarkSlateGray;
            this.ProcessesCB.Cursor = System.Windows.Forms.Cursors.Hand;
            this.ProcessesCB.DropDownHeight = 100;
            this.ProcessesCB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.ProcessesCB.DropDownWidth = 300;
            this.ProcessesCB.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.ProcessesCB.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F);
            this.ProcessesCB.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.ProcessesCB.IntegralHeight = false;
            this.ProcessesCB.Location = new System.Drawing.Point(4, 62);
            this.ProcessesCB.Margin = new System.Windows.Forms.Padding(3, 1, 3, 1);
            this.ProcessesCB.MaxDropDownItems = 10;
            this.ProcessesCB.Name = "ProcessesCB";
            this.ProcessesCB.Size = new System.Drawing.Size(0, 26);
            this.ProcessesCB.TabIndex = 31;
            this.ToolTip.SetToolTip(this.ProcessesCB, "Выберите процесс");
            this.ProcessesCB.Click += new System.EventHandler(this.ProcessesCB_Click);
            // 
            // RunAfterTimeLabel
            // 
            this.RunAfterTimeLabel.BackColor = System.Drawing.Color.Transparent;
            this.RunAfterTimeLabel.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.RunAfterTimeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.RunAfterTimeLabel.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.RunAfterTimeLabel.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.RunAfterTimeLabel.Location = new System.Drawing.Point(167, 94);
            this.RunAfterTimeLabel.Name = "RunAfterTimeLabel";
            this.RunAfterTimeLabel.Size = new System.Drawing.Size(195, 50);
            this.RunAfterTimeLabel.TabIndex = 32;
            // 
            // AboutDevLabel
            // 
            this.AboutDevLabel.AutoSize = true;
            this.AboutDevLabel.BackColor = System.Drawing.Color.Transparent;
            this.AboutDevLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.AboutDevLabel.Location = new System.Drawing.Point(72, 133);
            this.AboutDevLabel.Name = "AboutDevLabel";
            this.AboutDevLabel.Size = new System.Drawing.Size(203, 16);
            this.AboutDevLabel.TabIndex = 33;
            this.AboutDevLabel.Text = "Разработчик: Юрий Задрыгун";
            // 
            // Timer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(11F, 24F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.AutoValidate = System.Windows.Forms.AutoValidate.Disable;
            this.BackColor = System.Drawing.Color.DarkSlateGray;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.ClientSize = new System.Drawing.Size(355, 152);
            this.Controls.Add(this.AboutDevLabel);
            this.Controls.Add(this.StartTimerButton);
            this.Controls.Add(this.ProcessesCB);
            this.Controls.Add(this.ActionCB);
            this.Controls.Add(this.CancelTimerButton);
            this.Controls.Add(this.Seconds);
            this.Controls.Add(this.SLabel);
            this.Controls.Add(this.Minutes);
            this.Controls.Add(this.Hours);
            this.Controls.Add(this.MLabel);
            this.Controls.Add(this.HLabel);
            this.Controls.Add(this.WhenCB);
            this.Controls.Add(this.RunAfterTimeLabel);
            this.Controls.Add(this.CurrentTimeLabel);
            this.Cursor = System.Windows.Forms.Cursors.Default;
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.ForeColor = System.Drawing.Color.LightSeaGreen;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.Name = "Timer";
            this.Tag = "";
            this.Text = "Таймер";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Timer_FormClosing);
            this.Resize += new System.EventHandler(this.Timer_Minimize);
            ((System.ComponentModel.ISupportInitialize)(this.Hours)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.Minutes)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.Seconds)).EndInit();
            this.ContextMenuTray.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        
        #endregion
        private System.Windows.Forms.Label HLabel;
        private System.Windows.Forms.Label MLabel;
        private System.Windows.Forms.Label SLabel;
        private System.Windows.Forms.NumericUpDown Hours;
        private System.Windows.Forms.NumericUpDown Minutes;
        private System.Windows.Forms.NumericUpDown Seconds;
        private System.Windows.Forms.Timer Timer4UpdCurTime;
        private System.Windows.Forms.Button CancelTimerButton;
        private System.Windows.Forms.Button StartTimerButton;
        private System.Windows.Forms.ComboBox ActionCB;
        private System.Windows.Forms.ComboBox WhenCB;
        private System.Windows.Forms.Label CurrentTimeLabel;
        private System.Windows.Forms.Timer Timer4RunAction;
        private System.Windows.Forms.ComboBox ProcessesCB;
        private System.Windows.Forms.Label RunAfterTimeLabel;
        private System.Windows.Forms.ContextMenuStrip ContextMenuTray;
        private System.Windows.Forms.ToolStripMenuItem Выйти;
        private System.Windows.Forms.ToolStripMenuItem ЗапуститьТаймер;
        private System.Windows.Forms.ToolStripMenuItem ВыключитьТаймер;
        private System.Windows.Forms.ToolStripSeparator Сепаратюга;
        private System.Windows.Forms.NotifyIcon Tray;
        private System.Windows.Forms.ToolTip ToolTip;
        private System.Windows.Forms.Label AboutDevLabel;
    }
}

