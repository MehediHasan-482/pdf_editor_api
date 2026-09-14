def translate_text(text: str, source_language: str, target_language: str) -> str:
    """
    Translation adapter.

    Replace this implementation with the translation provider/model selected
    for the assessment. Keeping it behind this function makes the API/service
    layer independent of the provider.
    """
    if source_language == target_language:
        return text

    # Development fallback so the API remains runnable without an API key.
    return f"[{target_language}] {text}"
