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

;; From pelican-mode
(defun pelican-timestamp-now ()
  "Generate a Pelican-compatible timestamp."
  (format-time-string "%Y-%m-%d %H:%M"))

(defun pelican-is-markdown ()
  "Check if the buffer is likely using Markdown."
  (eq major-mode 'markdown-mode))

(defun pelican-field (name value)
  "Helper to format a field NAME and VALUE."
  (if value (format "%s: %s\n" name value) ""))

(defun pelican-markdown-header (title date status category tags slug)
  "Generate a Pelican Markdown header.

All parameters but TITLE may be nil to omit them. DATE may be a
string or 't to use the current date and time."
  (let ((title (format "Title: %s\n" title))
        (status (pelican-field "Status" status))
        (category (pelican-field "Category" category))
        (tags (pelican-field "Tags" tags))
        (slug (pelican-field "Slug" slug))
        (date (if date (format "Date: %s\n"
                               (if (stringp date) date
                                   (pelican-timestamp-now)))
                  "")))
    (concat title date status tags category slug "\n")))

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

(defun qblog/format-title-as-directory (slug)
  (concat (format-time-string "%Y-%m-%d")
          "-"
          slug))

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
  (make-directory (expand-file-name (concat "~/Pictures/" (qblog/format-title-as-directory slug))))
  (find-file (expand-file-name (concat qblog/blog-base-dir "/" blog "/" qblog/blog-post-dir "/" filename)))
  (markdown-mode)
  (insert (pelican-markdown-header title (pelican-timestamp-now) "draft" nil tags slug)))

(defun qblog/setup-post-editing ()
  "Hook for use in whatever mode we expect blog posts to be
  written in (markdown, rst, etc). Check whenever the opened file
  is in a blog content directory. If it is, set up the required
  buffer variables.")

(provide 'qblog)
