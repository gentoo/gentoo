# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20"

GITHUB_URI="https://github.com/Flameeyes/${PN}"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="${GITHUB_URI}.git"
fi

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKGEM_GESPEC="${PN}.gemspec"

inherit ruby-fakegem ${EGIT_REPO_URI:+git-2}

if [[ -n ${EGIT_REPO_URI} ]]; then
	SRC_URI=""
else
	SRC_URI="${GITHUB_URI}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Ruby library to access ELF files information"
HOMEPAGE="http://www.flameeyes.eu/projects/ruby-elf"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"

ruby_add_bdepend "
	test? ( dev-ruby/test-unit:2 )
	dev-ruby/rake"

# for the man pages
DEPEND+="
	dev-libs/libxslt
	app-text/docbook-xsl-ns-stylesheets"

RDEPEND+="
	virtual/man"

if [[ ${PV} == "9999" ]]; then
	all_ruby_unpack() {
		git_src_unpack
	}
fi

all_ruby_compile() {
	# build the man pages
	rake manpages || die "rake manpages failed"
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}

all_ruby_install() {
	all_fakegem_install

	doman manpages/*.1
	dodoc DONATING README.md
}
