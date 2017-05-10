# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Compiled binaries for Metasploit's Meterpreter"
HOMEPAGE="https://rubygems.org/gems/metasploit-payloads"

LICENSE="BSD"

SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

#no tests
RESTRICT="test strip"

QA_PREBUILT="
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/msflinker_linux_x86.bin
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/ext_server_sniffer.lso
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/ext_server_networkpug.lso
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/ext_server_stdapi.lso
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs/armeabi/libndkstager.so
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs/mips/libndkstager.so
	usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs/x86/libndkstager.so
	"

src_install() {
	ruby-ng_src_install
	#tell revdep-rebuild to ignore binaries meant for the target
	dodir /etc/revdep-rebuild
	cat <<-EOF > "${ED}"/etc/revdep-rebuild/99-${PN}-${SLOT} || die
		#These dirs contain prebuilt binaries for running on the TARGET not the HOST
		SEARCH_DIRS_MASK="/usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs"
	EOF
}
