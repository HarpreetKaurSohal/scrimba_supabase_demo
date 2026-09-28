import { openai, supabase } from './config.js';
import podcasts from './content.js';

async function main(input) {
  const data = await Promise.all(
    input.map( async (textChunk) => {
        const embeddingResponse = await openai.embeddings.create({
            model: "text-embedding-ada-002",
            input: textChunk
        });
        return { 
          content: textChunk, 
          embedding: embeddingResponse.data[0].embedding 
        }
    })
  );
  
  // Insert content and embedding into Supabase
  //data must be of same format as supabase table created
  await supabase.from('documents').insert(data); 
  console.log('Embedding and storing complete!');
}

main(podcasts)