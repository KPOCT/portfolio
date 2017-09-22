namespace Intellect_Battle__AnswerFinder_
{
    partial class AnswerFinder
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
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("Введите минимум 6 символов.");
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(AnswerFinder));
            this.KeyWord = new System.Windows.Forms.TextBox();
            this.KeyWordLabel = new System.Windows.Forms.Label();
            this.ResultLabel = new System.Windows.Forms.Label();
            this.Result = new System.Windows.Forms.TreeView();
            this.ClearKeyWord = new System.Windows.Forms.Button();
            this.Timer = new System.Windows.Forms.Timer(this.components);
            this.Minimize = new System.Windows.Forms.Button();
            this.Close = new System.Windows.Forms.Button();
            this.Maximize = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // KeyWord
            // 
            this.KeyWord.AccessibleDescription = "Введите символы из вопроса:";
            this.KeyWord.AccessibleName = "KeyWord";
            this.KeyWord.AccessibleRole = System.Windows.Forms.AccessibleRole.Text;
            this.KeyWord.AllowDrop = true;
            this.KeyWord.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(15)))), ((int)(((byte)(15)))), ((int)(((byte)(15)))));
            this.KeyWord.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.KeyWord.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.KeyWord.ForeColor = System.Drawing.Color.OrangeRed;
            this.KeyWord.Location = new System.Drawing.Point(13, 38);
            this.KeyWord.Name = "KeyWord";
            this.KeyWord.Size = new System.Drawing.Size(951, 26);
            this.KeyWord.TabIndex = 24;
            this.KeyWord.WordWrap = false;
            this.KeyWord.TextChanged += new System.EventHandler(this.Find);
            this.KeyWord.KeyDown += new System.Windows.Forms.KeyEventHandler(this.KeyWord_KeyDown);
            // 
            // KeyWordLabel
            // 
            this.KeyWordLabel.AutoSize = true;
            this.KeyWordLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 13F);
            this.KeyWordLabel.ForeColor = System.Drawing.Color.Gold;
            this.KeyWordLabel.Location = new System.Drawing.Point(9, 14);
            this.KeyWordLabel.Name = "KeyWordLabel";
            this.KeyWordLabel.Size = new System.Drawing.Size(264, 22);
            this.KeyWordLabel.TabIndex = 25;
            this.KeyWordLabel.Text = "Введите символы из вопроса:";
            // 
            // ResultLabel
            // 
            this.ResultLabel.AutoSize = true;
            this.ResultLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 13F);
            this.ResultLabel.ForeColor = System.Drawing.Color.Gold;
            this.ResultLabel.Location = new System.Drawing.Point(9, 78);
            this.ResultLabel.Name = "ResultLabel";
            this.ResultLabel.Size = new System.Drawing.Size(163, 22);
            this.ResultLabel.TabIndex = 26;
            this.ResultLabel.Text = "Результат поиска:";
            // 
            // Result
            // 
            this.Result.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(15)))), ((int)(((byte)(15)))), ((int)(((byte)(15)))));
            this.Result.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F, System.Drawing.FontStyle.Bold);
            this.Result.ForeColor = System.Drawing.Color.OrangeRed;
            this.Result.FullRowSelect = true;
            this.Result.LineColor = System.Drawing.Color.FromArgb(((int)(((byte)(15)))), ((int)(((byte)(15)))), ((int)(((byte)(15)))));
            this.Result.Location = new System.Drawing.Point(13, 100);
            this.Result.Name = "Result";
            treeNode1.ForeColor = System.Drawing.Color.Red;
            treeNode1.Name = "Введите минимум 6 символов.";
            treeNode1.Text = "Введите минимум 6 символов.";
            this.Result.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode1});
            this.Result.Size = new System.Drawing.Size(975, 388);
            this.Result.TabIndex = 27;
            // 
            // ClearKeyWord
            // 
            this.ClearKeyWord.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(15)))), ((int)(((byte)(15)))), ((int)(((byte)(15)))));
            this.ClearKeyWord.Cursor = System.Windows.Forms.Cursors.Hand;
            this.ClearKeyWord.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(10)))), ((int)(((byte)(10)))));
            this.ClearKeyWord.FlatAppearance.MouseOverBackColor = System.Drawing.Color.LightGray;
            this.ClearKeyWord.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.ClearKeyWord.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.ClearKeyWord.ForeColor = System.Drawing.Color.DimGray;
            this.ClearKeyWord.Location = new System.Drawing.Point(963, 38);
            this.ClearKeyWord.Name = "ClearKeyWord";
            this.ClearKeyWord.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ClearKeyWord.Size = new System.Drawing.Size(24, 26);
            this.ClearKeyWord.TabIndex = 30;
            this.ClearKeyWord.Text = "X";
            this.ClearKeyWord.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.ClearKeyWord.UseVisualStyleBackColor = false;
            this.ClearKeyWord.Click += new System.EventHandler(this.ClearKeyWord_Click);
            // 
            // Timer
            // 
            this.Timer.Interval = 1000;
            this.Timer.Tick += new System.EventHandler(this.Timer_Tick);
            // 
            // Minimize
            // 
            this.Minimize.BackColor = System.Drawing.Color.Transparent;
            this.Minimize.FlatAppearance.BorderColor = System.Drawing.Color.Yellow;
            this.Minimize.FlatAppearance.BorderSize = 0;
            this.Minimize.FlatAppearance.CheckedBackColor = System.Drawing.Color.Transparent;
            this.Minimize.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.Minimize.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.Minimize.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Minimize.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Minimize.ForeColor = System.Drawing.Color.White;
            this.Minimize.Location = new System.Drawing.Point(920, 10);
            this.Minimize.Name = "Minimize";
            this.Minimize.Size = new System.Drawing.Size(23, 22);
            this.Minimize.TabIndex = 32;
            this.Minimize.Text = "—";
            this.Minimize.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.Minimize.UseVisualStyleBackColor = false;
            this.Minimize.Click += new System.EventHandler(this.Minimize_Click);
            this.Minimize.MouseEnter += new System.EventHandler(this.Minimize_MouseEnter);
            this.Minimize.MouseLeave += new System.EventHandler(this.WhiteText);
            // 
            // Close
            // 
            this.Close.BackColor = System.Drawing.Color.Transparent;
            this.Close.FlatAppearance.BorderColor = System.Drawing.Color.Red;
            this.Close.FlatAppearance.BorderSize = 0;
            this.Close.FlatAppearance.CheckedBackColor = System.Drawing.Color.Transparent;
            this.Close.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.Close.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.Close.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Close.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Close.ForeColor = System.Drawing.Color.White;
            this.Close.Location = new System.Drawing.Point(965, 3);
            this.Close.Name = "Close";
            this.Close.Size = new System.Drawing.Size(23, 29);
            this.Close.TabIndex = 34;
            this.Close.Text = "x";
            this.Close.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.Close.UseVisualStyleBackColor = false;
            this.Close.Click += new System.EventHandler(this.Close_Click);
            this.Close.MouseEnter += new System.EventHandler(this.Close_MouseEnter);
            this.Close.MouseLeave += new System.EventHandler(this.WhiteText);
            // 
            // Maximize
            // 
            this.Maximize.BackColor = System.Drawing.Color.Transparent;
            this.Maximize.FlatAppearance.BorderColor = System.Drawing.Color.Orange;
            this.Maximize.FlatAppearance.BorderSize = 0;
            this.Maximize.FlatAppearance.CheckedBackColor = System.Drawing.Color.Transparent;
            this.Maximize.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.Maximize.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.Maximize.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.Maximize.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Maximize.ForeColor = System.Drawing.Color.White;
            this.Maximize.Location = new System.Drawing.Point(944, 4);
            this.Maximize.Name = "Maximize";
            this.Maximize.Size = new System.Drawing.Size(23, 28);
            this.Maximize.TabIndex = 33;
            this.Maximize.Text = "□";
            this.Maximize.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.Maximize.UseVisualStyleBackColor = false;
            this.Maximize.Click += new System.EventHandler(this.Maximize_Click);
            this.Maximize.MouseEnter += new System.EventHandler(this.Maximize_MouseEnter);
            this.Maximize.MouseLeave += new System.EventHandler(this.WhiteText);
            // 
            // AnswerFinder
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(11F, 24F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoValidate = System.Windows.Forms.AutoValidate.Disable;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(30)))));
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.ClientSize = new System.Drawing.Size(1000, 500);
            this.Controls.Add(this.KeyWord);
            this.Controls.Add(this.Maximize);
            this.Controls.Add(this.Close);
            this.Controls.Add(this.Minimize);
            this.Controls.Add(this.Result);
            this.Controls.Add(this.ClearKeyWord);
            this.Controls.Add(this.ResultLabel);
            this.Controls.Add(this.KeyWordLabel);
            this.Cursor = System.Windows.Forms.Cursors.Default;
            this.DoubleBuffered = true;
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F);
            this.ForeColor = System.Drawing.Color.Gold;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MinimumSize = new System.Drawing.Size(350, 230);
            this.Name = "AnswerFinder";
            this.Tag = "";
            this.Text = "Интеллект-Баттл (Поисковик ответов)";
            this.SizeChanged += new System.EventHandler(this.AnswerFinder_SizeChanged);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.AnswerFinder_MouseDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.TextBox KeyWord;
        private System.Windows.Forms.Label KeyWordLabel;
        private System.Windows.Forms.Label ResultLabel;
        private System.Windows.Forms.TreeView Result;
        private System.Windows.Forms.Timer Timer;
        private System.Windows.Forms.Button ClearKeyWord;
        private System.Windows.Forms.Button Minimize;
        private new System.Windows.Forms.Button Close;
        private System.Windows.Forms.Button Maximize;
    }
}

