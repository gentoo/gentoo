# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/meterpreter_bins/meterpreter_bins-0.0.10.ebuild,v 1.1 2014/10/19 23:24:24 zerochaos Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

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
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/msflinker_linux_x86.bin
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/ext_server_sniffer.lso
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/ext_server_networkpug.lso
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/meterpreter/ext_server_stdapi.lso
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs/armeabi/libndkstager.so
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs/mips/libndkstager.so
	usr/$(get_libdir)/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs/x86/libndkstager.so
	"

src_install() {
	ruby-ng_src_install
	#tell revdep-rebuild to ignore binaries meant for the target
	dodir /etc/revdep-rebuild
	cat <<-EOF > "${ED}"/etc/revdep-rebuild/99-${PN}-${SLOT}
		#These dirs contain prebuilt binaries for running on the TARGET not the HOST
		SEARCH_DIRS_MASK="/usr/lib*/ruby/gems/*/gems/${PN}-${SLOT}/data/android/libs"
	EOF
}
