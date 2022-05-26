# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_EXTENSIONS=(bindings/ruby/extconf.rb)

inherit ruby-fakegem

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
