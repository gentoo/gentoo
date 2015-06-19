# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pdf-reader/pdf-reader-1.1.1-r1.ebuild,v 1.3 2014/11/10 15:54:48 mrueg Exp $

EAPI=5

GITHUB_USER=yob

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc TODO"

inherit ruby-fakegem

DESCRIPTION="PDF parser conforming as much as possible to the PDF specification from Adobe"
HOMEPAGE="http://github.com/yob/pdf-reader/"

# We cannot use the gem distributions because they don't contain the
# tests' data, we have to rely on the git tags.
SRC_URI="http://github.com/${GITHUB_USER}/${PN}/tarball/v${PV} -> ${PN}-git-${PV}.tgz"
RUBY_S="${GITHUB_USER}-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

ruby_add_rdepend "dev-ruby/ascii85 dev-ruby/ruby-rc4"

# rspec is loaded even during doc generation, so keep it around :(
ruby_add_bdepend ">=dev-ruby/rspec-2.1:2"

all_ruby_prepare() {
	# Remove bundler support
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
	rm Gemfile || die

	# Roodi is not yet available in CVS.
	sed -i -e '/roodi/d' Rakefile || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/* || die
}
