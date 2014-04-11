(defvar qblog/blog-base-dir nil
  "Directory blogs are in")

(defvar qblog/blog-post-dir nil
  "Subdirectory of blog directory that we expect posts to be
  in.")

(defvar qblog/blog-list nil
  "List of blog directories")

(defvar qblog/image-dir nil
  "Place where new image directories for blog posts will be
  stored.")

(defvar qblog/blog-file-extension nil
  "Extension for filetype of blog posts.")

(defun qblog/slugify (s)
  "Turn a string into a slug."
  (replace-regexp-in-string " " "-"
                            (downcase
                             (replace-regexp-in-string "[^A-Za-z0-9 ]" "" s))))

(defun qblog/format-title-as-filename (slug)
  (concat (format-time-string "%Y-%m-%d")
          "-"
          slug
          qblog/blog-file-extension))

(defun qblog/change-title (title)
  )

(defun qblog/insert-markdown-image-link (url filename)
  (interactive "sImage URL: \nsFilename to save: ")
  (shell-command (format "wget -O %s %s" filename url) nil nil))

(defun qblog/retrieve-and-format-image (url finalname)
  "Retrieve and format image for use in current blog post.

Given a URL, wget the image. If the width is larger than the max
width setting, resize it. Copy to final directory under new
name."
  (interactive)
  )

(defun qblog/new-blog-post (blog title slug filename tags)
  "Create a new blog post in the specified blog. Also create a
  picture directory where images will be stored."
  (interactive
   (let*
       ((blog  (ido-completing-read "Blog: " qblog/blog-list))
        (title (read-string "Title: "))
        (slug (read-string "Slug: " (qblog/slugify title))))
     (list blog title slug
           (read-string "Filename: " (qblog/format-title-as-filename slug))
           (read-string "Tags: "))))
  (find-file (expand-file-name (concat qblog/blog-base-dir "/" blog "/" qblog/blog-post-dir "/" filename)))
  (markdown-mode)
  (insert (pelican-markdown-header title (pelican-timestamp-now) "draft" nil tags slug)))

(defun qblog/setup-post-editing ()
  "Hook for use in whatever mode we expect blog posts to be
  written in (markdown, rst, etc). Check whenever the opened file
  is in a blog content directory. If it is, set up the required
  buffer variables.")

(provide 'qblog)

(setq qblog/blog-base-dir (expand-file-name "~/code/git-projects"))
(setq qblog/blog-post-dir "/content/posts/")
(setq qblog/blog-list '("slashdong.org" "nonpolynomial.com" "openyou.org" "feverything.com"))
(setq qblog/image-base-dir "~/Pictures/")
(setq qblog/blog-file-extension ".markdown")
