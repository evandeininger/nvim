return {
  "emrearmagan/atlas.nvim",
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim", -- optional, good for Jira markdown
    "sindrets/diffview.nvim",                    -- optional, for PR diffs
  },
  config = function()
    require("atlas").setup({
      issues = {
        max_results = 100,
        fetch_parent_issues = true,
        providers = {
          jira = {
            base_url = "https://secondstep.atlassian.net",
            email = "edeininger@cfchildren.org",
            token = "ATATT3xFfGF0yD8rAyzXkKogMFu81QDvC9G2MmY-eElcB1zBlGsVFHd_GL4khvqC33JPNnj-gWr6mjZcOqetrw8gFOg-07NdpTN2hO2l3QiG9atoan4M5nWVJcPU4_8JXA5OtvQ4Q9EVV_lMG1yUxrOGe6Irx7KXHEgArBgM4jlAQ6K4pTEGCs8=74EFA781",
            cache_ttl = 300,
            project_config = {
              -- adjust if your story-points field is different
              story_points_field = "customfield_10016",
              KAN = {
                -- you can mirror the custom-field config from the README later
              },
            },
            views = {
              {
                name = "Current PIT Sprint",
                key = "P",
                jql = 'project = LEARN AND "Team[Team]" = 4cf0afd2-c77a-4c6f-bbfb-02ee34fc35ff AND assignee = currentUser() AND Sprint in openSprints()',
              },
              {
                name = "My Board",
                key = "I",
                jql = "assignee = currentUser() AND NOT status IN (Cancelled, Done) ORDER BY updated DESC",
              },
            },
          },
        },
      },
      pulls = {
        diff = {
          open_cmd = "DiffviewOpen",
        },
        providers = {
          github = {
            cache_ttl = 300,
            views = {
              {
                name = "My PRs",
                key = "1",
                search = "author:@me sort:updated-desc",
              },
              {
                name = "Committee-for-Children",
                key = "2",
                search = "org:Committee-for-Children sort:updated-desc",
              },
            },
          },
        },
      },
    })
  end,
}

