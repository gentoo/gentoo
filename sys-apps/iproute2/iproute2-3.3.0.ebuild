# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs flag-o-matic multilib

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="mirror://kernel/linux/utils/net/${PN}/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
fi

DESCRIPTION="kernel routing and traffic control utilities"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2"

LICENSE="GPL-2"
SLOT="0"
IUSE="atm berkdb +iptables ipv6 minimal"

RDEPEND="!net-misc/arpd
	iptables? ( >=net-firewall/iptables-1.4.5 )
	!minimal? ( berkdb? ( sys-libs/db ) )
	atm? ( net-dialup/linux-atm )"
DEPEND="${RDEPEND}
	iptables? ( virtual/pkgconfig )
	sys-devel/bison
	sys-devel/flex
	>=sys-kernel/linux-headers-2.6.27
	elibc_glibc? ( >=sys-libs/glibc-2.7 )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.1.0-mtu.patch #291907
	use ipv6 || epatch "${FILESDIR}"/${PN}-3.1.0-no-ipv6.patch #326849

	sed -i \
		-e '/^CC =/d' \
		-e "/^LIBDIR/s:=.*:=/$(get_libdir):" \
		-e "s:-O2:${CFLAGS} ${CPPFLAGS}:" \
		Makefile || die

	# build against system headers
	rm -r include/netinet #include/linux include/ip{,6}tables{,_common}.h include/libiptc
	sed -i 's:TCPI_OPT_ECN_SEEN:16:' misc/ss.c || die

	# don't build arpd if USE=-berkdb #81660
	use berkdb || sed -i '/^TARGETS=/s: arpd : :' misc/Makefile

	use minimal && sed -i -e '/^SUBDIRS=/s:=.*:=lib tc:' Makefile
}

src_configure() {
	tc-export AR CC PKG_CONFIG

	# This sure is ugly.  Should probably move into toolchain-funcs at some point.
	local setns
	pushd "${T}" >/dev/null
	echo 'main(){return setns();};' > test.c
	${CC} ${CFLAGS} ${LDFLAGS} test.c >&/dev/null && setns=y || setns=n
	echo 'main(){};' > test.c
	${CC} ${CFLAGS} ${LDFLAGS} test.c -lresolv >&/dev/null || sed -i '/^LDLIBS/s:-lresolv::' "${S}"/Makefile
	popd >/dev/null

	cat <<-EOF > Config
	TC_CONFIG_ATM := $(usex atm y n)
	TC_CONFIG_XT  := $(usex iptables y n)
	IP_CONFIG_SETNS := ${setns}
	# Use correct iptables dir, #144265 #293709
	IPT_LIB_DIR := $(use iptables && ${PKG_CONFIG} xtables --variable=xtlibdir)
	EOF
}

src_install() {
	if use minimal ; then
		into /
		dosbin tc/tc
		return 0
	fi

	emake \
		DESTDIR="${D}" \
		LIBDIR="${EPREFIX}"/$(get_libdir) \
		SBINDIR="${EPREFIX}"/sbin \
		CONFDIR="${EPREFIX}"/etc/iproute2 \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		MANDIR="${EPREFIX}"/usr/share/man \
		ARPDDIR="${EPREFIX}"/var/lib/arpd \
		install

	dolib.a lib/libnetlink.a
	insinto /usr/include
	doins include/libnetlink.h

	if use berkdb ; then
		dodir /var/lib/arpd
		# bug 47482, arpd doesn't need to be in /sbin
		dodir /usr/sbin
		mv "${ED}"/sbin/arpd "${ED}"/usr/sbin/
	fi
}
