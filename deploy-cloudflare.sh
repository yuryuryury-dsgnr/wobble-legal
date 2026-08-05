#!/bin/sh
# Публикация этих же страниц на wobl-legal.pages.dev — канонический адрес,
# на который ссылаются App Store Connect и приложение.
#
# Единственное отличие от версии для GitHub Pages: Cloudflare Pages срезает
# расширение (.../terms.html отдаёт 308 на .../terms), поэтому внутренние
# ссылки переводятся в бесрасширенный вид — иначе каждый переход внутри
# сайта шёл бы через редирект. Опубликованные адреса — тоже без .html:
# они отвечают 200 напрямую, а битая или редиректная ссылка на ревью
# в App Store стоит отказа.
set -e
out=$(mktemp -d)
cp index.html terms.html privacy.html support.html style.css "$out/"
sed -i '' -E 's/href="(terms|privacy|support)\.html"/href="\1"/g' "$out"/*.html
npx --yes wrangler@4 pages deploy "$out" --project-name wobl-legal --branch main --commit-dirty=true
rm -rf "$out"
