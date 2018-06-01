# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="assets public views"

inherit ruby-fakegem

DESCRIPTION="Generates a HTML report of your SimpleCov ruby code coverage results"
HOMEPAGE="https://github.com/colszowka/simplecov"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0.10"
IUSE="doc"
