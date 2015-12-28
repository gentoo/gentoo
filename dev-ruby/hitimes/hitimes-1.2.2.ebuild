# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md HISTORY.md"

inherit multilib ruby-fakegem

DESCRIPTION="A fast, high resolution timer library"
HOMEPAGE="https://github.com/copiousfreetime/hitimes"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/RUBY_VERSION >= '1.9.2'/,+4d"  spec/spec_helper.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/hitimes/c extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/hitimes/c V=1
	cp ext/hitimes/c/hitimes$(get_modname) lib/hitimes || die
}

each_ruby_test() {
	${RUBY} -Ilib:spec:. -e 'Dir["spec/*_spec.rb"].each{|f| require f}' || die
}
