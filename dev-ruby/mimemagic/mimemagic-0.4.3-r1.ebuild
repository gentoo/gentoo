# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC=mimemagic.gemspec

inherit prefix ruby-fakegem

DESCRIPTION="Fast mime detection by extension or content"
HOMEPAGE="https://github.com/mimemagicrb/mimemagic"
SRC_URI="https://github.com/mimemagicrb/mimemagic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND+=" x11-misc/shared-mime-info"

ruby_add_rdepend "
	dev-ruby/nokogiri
	dev-ruby/rake
"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	cp "${FILESDIR}/${PN}-0.3.9-path.rb" lib/mimemagic/path.rb || die
	eprefixify lib/mimemagic/path.rb

	sed -i -e 's/git ls-files/find * -print/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each {|f| require f}' || die
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_extensions_installed
}
