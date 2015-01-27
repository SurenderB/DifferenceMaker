namespace FCSAmerica.AYB.Old_App_Code
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    public class CSV
    {
        List<List<object>> _rows;

        public CSV()
        {
            _rows = new List<List<object>>();
        }

        public void AddRow(params object[] rowValues)
        {
            _rows.AddList(rowValues);
        }

        public override string ToString()
        {
            var sb = new StringBuilder();
            foreach (var row in _rows)
                sb.AppendLine(EscapeCommasAndQuotes(row.Select(x => x.ToString())));
            return sb.ToString();
        }

        public string EscapeCommasAndQuotes(IEnumerable<string> cells)
        {
            return "\"" + string.Join("\",\"", cells.Select(x => x.Replace("\"", "\"\"")).ToArray()) + "\"";
        }
    }
}