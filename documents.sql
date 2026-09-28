-- run inside Supabase sqlEditor

-- Create a table to store your documents
create table documents (
  id bigserial primary key,
  content text, -- corresponds to the "text chunk"
  embedding vector(1536) -- 1536 works for OpenAI embeddings
);

-- Create a function to search for documents
create or replace function match_documents (
  --1536- its the num OpenAI text embedding model outputs
  query_embedding vector(1536),
  match_threshold float,
  match_count int
)
-- it returns usefull information from the table like id, content and a similarity score
returns table (
  id bigint,
  content text,
  similarity float
)
-- <=> cosine distance operator provided by supabse PG vector extension
language sql stable
as $$
  select
    documents.id,
    documents.content,
    1 - (documents.embedding <=> query_embedding) as similarity
  from documents
  where 1 - (documents.embedding <=> query_embedding) > match_threshold
  order by similarity desc
  limit match_count;
$$;