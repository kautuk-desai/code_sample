defmodule CodeSample do
  @spec get_comments!(String.t, String.t) :: integer
  def get_comments!(file_id, token) do
    case HTTPoison.get! "https://api.box.com/2.0/files/#{file_id}/comments", %{Authorization: "Bearer #{token}"} do
      %{status_code: 200, body: body} ->
        body
        |> Poison.decode!
        |> Map.get("entries")
      %{status_code: code, body: body} ->
        raise "Failed to get comments.  Received #{code}: #{body}"
    end
  end

  @doc """
  This method adds the comment to the pp file
  params: file_id, token, comment
  return: null
  """
  def add_comment!(file_id, token, comment) do
    case HTTPoison.post! "https://api.box.com/2.0/comments",
    Poison.encode!(%{item: %{type: "file", id: "#{file_id}"}, message: "#{comment}"}), %{Authorization: "Bearer #{token}"}, [] do
      %{status_code: 201, body: body} ->
        body
        |> Poison.decode!
      %{status_code: code, body: body} ->
        raise "Failed to add comments.  Received #{code}: #{body}"
    end
  end

  @doc """
  This method deletes the comment specificed by the comment id
  params: comment_id
  return: null
  """
  def delete_comment!(comment_id, token) do
    case HTTPoison.delete! "https://api.box.com/2.0/comments/#{comment_id}", %{Authorization: "Bearer #{token}"}, [] do
      %{status_code: 204} ->
        204
      %{status_code: code, body: body } ->
        raise "Failed to delete comments.  Received #{code}: #{body}"
    end
  end

  @doc """
  This method modifies the comment specificed by the comment id
  params: comment_id, new_comment
  return: null
  """
  def modify_comment!(comment_id, token, new_comment) do
    case HTTPoison.put! "https://api.box.com/2.0/comments/#{comment_id}",
    Poison.encode!(%{message: "#{new_comment}"}), %{Authorization: "Bearer #{token}"}, [] do
      %{status_code: 200, body: body} ->
        body
          |> Poison.decode!
          |> Map.get("message")
      %{status_code: code, body: body } ->
        raise "Failed to modify comments.  Received #{code}: #{body}"
    end
  end
end
