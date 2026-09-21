const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";

async function getApiStatus(): Promise<{ ok: boolean; detail: string }> {
  try {
    const response = await fetch(`${API_URL}/health`, { cache: "no-store" });
    if (!response.ok) {
      return { ok: false, detail: `API responded ${response.status}` };
    }
    return { ok: true, detail: "API, PostgreSQL and Redis all reachable." };
  } catch {
    return { ok: false, detail: `No response from ${API_URL}. Is the API running?` };
  }
}

export default async function Home() {
  const status = await getApiStatus();

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-1 flex-col justify-center gap-6 p-8">
      <div>
        <h1 className="text-4xl font-semibold tracking-tight">Buzzly</h1>
        <p className="mt-2 text-lg text-zinc-600 dark:text-zinc-400">
          Learn to code by actually coding.
        </p>
      </div>

      <div className="rounded-lg border border-black/[.08] p-4 dark:border-white/[.145]">
        <p className="font-medium">
          <span
            aria-hidden="true"
            className={`mr-2 inline-block size-2.5 rounded-full align-middle ${
              status.ok ? "bg-green-500" : "bg-red-500"
            }`}
          />
          Stage 0 &mdash; {status.ok ? "foundation running" : "backend unavailable"}
        </p>
        <p className="mt-2 text-sm text-zinc-600 dark:text-zinc-400">{status.detail}</p>
      </div>

      <p className="text-sm text-zinc-500">
        Next: AWS Cognito sign-up and login, then the Stage 1 lesson player.
      </p>
    </main>
  );
}
