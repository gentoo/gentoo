# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="assets public views"

inherit ruby-fakegem

DESCRIPTION="Generates a HTML report of your SimpleCov ruby code coverage results"
HOMEPAGE="https://github.com/simplecov-ruby/simplecov-html"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
SLOT="$(ver_cut 1-2)"
IUSE="doc"
