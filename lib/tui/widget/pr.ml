let closed_char = "\u{ebda}"
let open_char = "\u{ea64}"
let merged_char = "\u{e725}"

let section (tab : Model.Pr.t) =
  let open Pretty.Doc in
  let docs =
    match tab.error with
    | None ->
        let fmt_state = function
          | None -> str ""
          | Some Gh.Pr.Merged -> fmt Style.pr_merged merged_char
          | Some Gh.Pr.Open -> fmt Style.pr_open open_char
          | Some Gh.Pr.Closed -> fmt Style.pr_closed closed_char
        in
        let fmt_pr (pr : Gh.Pr.t) =
          Pretty.Doc.(
            horizontal
              [
                fmt_state pr.state;
                str " ";
                fmt Style.secondary (Printf.sprintf "#%d " pr.number);
                str pr.title;
                str " by ";
                fmt Style.bold (Printf.sprintf "@%s" pr.author);
              ])
        in
        tab.pull_requests |> Lazy.force |> List.map fmt_pr
    | Some error -> Common.fmt_error error
  in
  vertical docs
