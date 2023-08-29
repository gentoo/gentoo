# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin git-r3

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="https://www.exherbolinux.org/"
EGIT_REPO_URI="https://gitlab.exherbo.org/exherbo-misc/exheres-syntax"

LICENSE="vim"
SLOT="0"

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"

src_compile() { :; }
