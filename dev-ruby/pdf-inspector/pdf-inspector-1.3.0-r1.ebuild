# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A tool for analyzing PDF output"
HOMEPAGE="https://github.com/prawnpdf/pdf-inspector"

LICENSE="|| ( Ruby GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/pdf-reader-1.0:* <dev-ruby/pdf-reader-3:*"
