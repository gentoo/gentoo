# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md HISTORY.md"
RUBY_FAKEGEM_GEMSPEC="hitimes.gemspec"

inherit ruby-fakegem

DESCRIPTION="A fast, high resolution timer library"
HOMEPAGE="https://github.com/copiousfreetime/hitimes"
SRC_URI="https://github.com/copiousfreetime/hitimes/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -e '/\(focus\|pride\)/ s:^:#:' \
		-i spec/spec_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:spec:. -rminitest/autorun -e 'Dir["spec/*_spec.rb"].each{|f| require f}' || die
}
