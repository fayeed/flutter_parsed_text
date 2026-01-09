part of flutter_parsed_text;

/// Email Regex - A predefined type for handling email matching
///
/// Matches standard email addresses like user@example.com
const emailPattern = r"\b[\w\.-]+@[\w\.-]+\.\w{2,63}\b";

/// URL Regex - A predefined type for handling URL matching
///
/// Matches URLs starting with http://, https://, or www.
/// Supports URLs with commas, query parameters, fragments, and unicode characters.
const urlPattern =
    r"(?:https?:\/\/|www\.)[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=,]*)";

/// Phone Regex - A predefined type for handling phone matching
///
/// Matches various phone number formats including:
/// - International format: +1-800-555-1234
/// - US format: (800) 555-1234, 800-555-1234, 800.555.1234
/// - Local format: 555-1234
const phonePattern =
    r"(?:\+?1[-.\s]?)?(?:\(?\d{3}\)?[-.\s]?)?\d{3}[-.\s]?\d{4}\b";
