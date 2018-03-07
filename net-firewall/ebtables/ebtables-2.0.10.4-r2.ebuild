# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator toolchain-funcs flag-o-matic

MY_PV=$(replace_version_separator 3 '-' )
MY_P=${PN}-v${MY_PV}

DESCRIPTION="Controls Ethernet frame filtering on a Linux bridge, MAC NAT and brouting"
HOMEPAGE="http://ebtables.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="+perl static"

# The ebtables-save script is written in perl.
RDEPEND="perl? ( dev-lang/perl )
	net-misc/ethertypes"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use static; then
		ewarn "You've chosen static build which is useful for embedded devices."
		ewarn "It has no init script. Make sure that's really what you want."
	fi
}

src_prepare() {
	# Enhance ebtables-save to take table names as parameters bug #189315
	local PATCHES=( "${FILESDIR}/${PN}-2.0.8.1-ebt-save.diff" )

	default

	sed -i -e "s,^MANDIR:=.*,MANDIR:=/usr/share/man," \
		-e "s,^BINDIR:=.*,BINDIR:=/sbin," \
		-e "s,^INITDIR:=.*,INITDIR:=/usr/share/doc/${PF}," \
		-e "s,^SYSCONFIGDIR:=.*,SYSCONFIGDIR:=/usr/share/doc/${PF}," \
		-e "s,^LIBDIR:=.*,LIBDIR:=/$(get_libdir)/\$(PROGNAME)," Makefile
}

src_compile() {
	# This package uses _init functions to initialise extensions. With
	# --as-needed this will not work.
	append-ldflags $(no-as-needed)
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		$(use static && echo static)
}

src_install() {
	if ! use static; then
		emake DESTDIR="${D}" install
		keepdir /var/lib/ebtables/
		newinitd "${FILESDIR}"/ebtables.initd-r1 ebtables
		newconfd "${FILESDIR}"/ebtables.confd-r1 ebtables
		if ! use perl; then
			rm "${ED}"/sbin/ebtables-save || die
		fi
		# Bug 647458
		rm "${ED%/}"/etc/ethertypes || die
	else
		into /
		newsbin static ebtables
	fi
	dodoc ChangeLog THANKS
}
