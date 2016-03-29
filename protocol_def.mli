(* Name of the extension *)
type description = {
  name : string;
  version : string;
}

(* Services provided by extension *)
type capabilities = {
  reader: bool;
}

(* Reader protocol *)
module Reader : sig

  open Reader_def

  type request =
    | Load of buffer
    | Parse
    | Parse_line of Lexing.position * string
    | Parse_for_completion of Lexing.position
    | Get_ident_at of Lexing.position
    | Print of tree list

  type response =
    | Ret_not_a_reader
    | Ret_tree of tree
    | Ret_tree_for_competion of complete_info * tree
    | Ret_ident of string Location.loc list
    | Ret_printed of string list

end

(* Main protocol *)
type request =
  | Reader_request of Reader.request

type response =
  | Auxiliary of [`Notify of string | `Debug of string]
  | Reader_response of Reader.response
