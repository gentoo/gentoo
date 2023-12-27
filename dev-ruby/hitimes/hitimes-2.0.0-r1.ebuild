# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md HISTORY.md"

inherit ruby-fakegem

DESCRIPTION="A fast, high resolution timer library"
HOMEPAGE="https://github.com/copiousfreetime/hitimes"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e "/RUBY_VERSION >= '1.9.2'/,+4d"  spec/spec_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:spec:. -e 'Dir["spec/*_spec.rb"].each{|f| require f}' || die
}
