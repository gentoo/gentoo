# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="build"

inherit ruby-fakegem

DESCRIPTION="Compiled binaries for Metasploit's next-gen Meterpreter"
HOMEPAGE="https://rubygems.org/gems/metasploit_payloads-mettle"

LICENSE="BSD"

SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

#no tests
RESTRICT="test strip"

QA_PREBUILT="
	usr/lib*/ruby/gems/*/gems/${P}/build/mips-linux-muslsf/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/mips64-linux-muslsf/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/aarch64-linux-musl/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/armv5b-linux-musleabi/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/armv5l-linux-musleabi/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/i486-linux-musl/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/mipsel-linux-muslsf/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/powerpc-linux-muslsf/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/powerpc64le-linux-musl/bin/mettle
	usr/lib*/ruby/gems/*/gems/${P}/build/x86_64-linux-musl/bin/mettle
	"

src_install() {
	ruby-ng_src_install
	#tell revdep-rebuild to ignore binaries meant for the target
	dodir /etc/revdep-rebuild
	cat <<-EOF > "${ED}"/etc/revdep-rebuild/99-${PN}-${SLOT} || die
		#These dirs contain prebuilt binaries for running on the TARGET not the HOST
		SEARCH_DIRS_MASK="/usr/lib*/ruby/gems/*/gems/${P}/build"
	EOF
}
