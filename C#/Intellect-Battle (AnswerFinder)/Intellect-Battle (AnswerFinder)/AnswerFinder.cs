namespace Intellect_Battle__AnswerFinder_
{
    public partial class AnswerFinder : System.Windows.Forms.Form
    {
        public AnswerFinder()
        {
            InitializeComponent();
        }

        private void Find(object sender, System.EventArgs e)
        {
            if (KeyWord.Text.Length > 5)
            {
                if (Timer.Enabled == false)
                {
                    Timer.Enabled = true;
                }
                else
                {
                    Timer.Enabled = false;
                    Timer.Enabled = true;
                }
            }
            else
            {
                Timer.Enabled = false;
                Result.Nodes.Clear();
                Result.Nodes.Add("Введите минимум 6 символов.").ForeColor = System.Drawing.Color.Red;
                Result.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            }
        }

        private void CreateTreeList()
        {
            Result.Nodes.Clear();
            string[] String = Properties.Resources.Интеллект_баттл.Split(new char[] { '\n' }, System.StringSplitOptions.RemoveEmptyEntries);
            string StrTemp = KeyWord.Text;
            StrTemp = System.Text.RegularExpressions.Regex.Escape(StrTemp);
            System.Text.RegularExpressions.Regex regex = new System.Text.RegularExpressions.Regex(StrTemp, System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            StrTemp = null;
            for (int i = 0; i < String.Length; i += 2)
            {
                if (regex.IsMatch(String[i]) && KeyWord.Text != "")
                {
                    System.Windows.Forms.TreeNode TreeItem = Result.Nodes.Add(String[i]);
                    TreeItem.Nodes.Add(String[i + 1]).ForeColor = System.Drawing.Color.Chartreuse;
                }
            }
            String = null;
            if (Result.Nodes.Count == 0)
            {
                if (KeyWord.Text.Length > 5)
                {
                    Result.Nodes.Add("Не найдено ни одного совпадения.").ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    Result.Nodes.Add("Введите минимум 6 символов.").ForeColor = System.Drawing.Color.Red;
                }
                Result.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            }
            else
            {
                Result.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            }
            Result.ExpandAll();
        }

        private void ClearKeyWord_Click(object sender, System.EventArgs e)
        {
            KeyWord.Text = "";
            KeyWord.Focus();
        }

        private void AnswerFinder_MouseDown(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            Capture = false;
            System.Windows.Forms.Message m = System.Windows.Forms.Message.Create(base.Handle, 0xa1, new System.IntPtr(2), System.IntPtr.Zero);
            WndProc(ref m);
        }

        private void AnswerFinder_SizeChanged(object sender, System.EventArgs e)
        {
            ClearKeyWord.Location = new System.Drawing.Point(ClientSize.Width - 37, 38);
            KeyWord.Size = new System.Drawing.Size(ClientSize.Width - 48, 26);
            Result.Size = new System.Drawing.Size(ClientSize.Width - 25, ClientSize.Height - 112);
            Minimize.Location = new System.Drawing.Point(ClientSize.Width - 80, 10);
            Maximize.Location = new System.Drawing.Point(ClientSize.Width - 56, 4);
            Close.Location = new System.Drawing.Point(ClientSize.Width - 35, 3);
        }

        private void Timer_Tick(object sender, System.EventArgs e)
        {
            CreateTreeList();
            Timer.Enabled = false;
        }

        protected override void WndProc(ref System.Windows.Forms.Message m)
        {
            if (m.Msg == 0x0084) //  WM_NCHITTEST 
            {
                int x = System.Windows.Forms.Cursor.Position.X - Location.X;
                int y = System.Windows.Forms.Cursor.Position.Y - Location.Y;
                if (x < 7)
                {
                    if (y < 7) m.Result = new System.IntPtr(13); // TOPLEFT
                    else if (y > (Size.Height - 7) && y < Size.Height) m.Result = new System.IntPtr(16); // BOTTOMLEFT
                    else m.Result = new System.IntPtr(10); // LEFT
                }
                else if (x > (Size.Width - 7) && x < Size.Width)
                {
                    if (y < 7) m.Result = new System.IntPtr(14); // TOPLEFT
                    else if (y > (Size.Height - 7) && y < Size.Height) m.Result = new System.IntPtr(17); // BOTTOMLEFT
                    else m.Result = new System.IntPtr(11); // RIGHT
                }
                else
                {
                    if (y < 7) m.Result = new System.IntPtr(12); // TOP
                    else if (y > (Size.Height - 7) && y < Size.Height) m.Result = new System.IntPtr(15); // BOTTOM
                    else base.WndProc(ref m);
                }
                x = '\0';
                x = '\0';
            }
            else
                base.WndProc(ref m);
        }

        private void Minimize_MouseEnter(object sender, System.EventArgs e)
        {
            Minimize.ForeColor = System.Drawing.Color.Yellow;
        }

        private void Maximize_MouseEnter(object sender, System.EventArgs e)
        {
            Maximize.ForeColor = System.Drawing.Color.Orange;
        }

        private void Close_MouseEnter(object sender, System.EventArgs e)
        {
            Close.ForeColor = System.Drawing.Color.Red;
        }

        private void WhiteText(object sender, System.EventArgs e)
        {
            System.Windows.Forms.Button Btn = (System.Windows.Forms.Button)sender;
            Btn.ForeColor = System.Drawing.Color.White;
            Btn = null;
        }

        private void Minimize_Click(object sender, System.EventArgs e)
        {
            WindowState = System.Windows.Forms.FormWindowState.Minimized;
        }

        private void Maximize_Click(object sender, System.EventArgs e)
        {
            if (WindowState == System.Windows.Forms.FormWindowState.Maximized)
            {
                WindowState = System.Windows.Forms.FormWindowState.Normal;
            }
            else
            {
                WindowState = System.Windows.Forms.FormWindowState.Maximized;
            }
        }

        private void Close_Click(object sender, System.EventArgs e)
        {
            Close();
        }

        private void KeyWord_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if ((e.KeyCode == System.Windows.Forms.Keys.Back) && e.Control)
            {
                e.SuppressKeyPress = true;
                if (KeyWord.SelectionLength > 0)
                {
                    KeyWord.SelectedText = "";
                }
                else
                {
                    int selStart = KeyWord.SelectionStart;
                    while (selStart > 0 && KeyWord.Text.Substring(selStart - 1, 1) == " ")
                    {
                        selStart--;
                    }
                    int prevSpacePos = -1;
                    if (selStart != 0)
                    {
                        prevSpacePos = KeyWord.Text.LastIndexOf(' ', selStart - 1);
                    }
                    selStart = '\0';
                    KeyWord.Select(prevSpacePos + 1, KeyWord.SelectionStart - prevSpacePos - 1);
                    prevSpacePos = '\0';
                    KeyWord.SelectedText = "";
                }
            }
        }
    }
}