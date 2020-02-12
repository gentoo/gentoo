# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit multilib ruby-fakegem

DESCRIPTION="System Information Gatherer And Reporter"
HOMEPAGE="http://sigar.hyperic.com/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND+=" || ( <sys-libs/glibc-2.26 net-libs/libtirpc )"

all_ruby_prepare() {
	sed -i -e '25i$CFLAGS += " -std=gnu89 -I/usr/include/tirpc"' \
		-e '25i$LDFLAGS += " -ltirpc"' bindings/ruby/extconf.rb || die

	# Fix compatibility with glibc 2.25
	sed -i -e '26i#include <sys/sysmacros.h>' \
		-e '27i#include <ctype.h>' bindings/ruby/rbsigar.c src/os/linux/linux_sigar.c || die
}

each_ruby_configure() {
	${RUBY} -Cbindings/ruby extconf.rb || die
}

each_ruby_compile() {
	emake -Cbindings/ruby V=1
	mkdir lib || die
	cp bindings/ruby/${PN}$(get_modname) lib/ || die
}
