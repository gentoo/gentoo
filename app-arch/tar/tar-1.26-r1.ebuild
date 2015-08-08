# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit flag-o-matic eutils autotools

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="http://www.gnu.org/software/tar/"
SRC_URI="mirror://gnu/tar/${P}.tar.bz2
	mirror://gnu-alpha/tar/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal nls static userland_GNU xattr"

RDEPEND="xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.10.35 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-xattr.patch #382067
	epatch "${FILESDIR}"/${P}-no-gets.patch
	eautoreconf

	if ! use userland_GNU ; then
		sed -i \
			-e 's:/backup\.sh:/gbackup.sh:' \
			scripts/{backup,dump-remind,restore}.in \
			|| die "sed non-GNU"
	fi
}

src_configure() {
	use static && append-ldflags -static
	FORCE_UNSAFE_CONFIGURE=1 \
	econf \
		--enable-backup-scripts \
		--bindir="${EPREFIX}"/bin \
		--libexecdir="${EPREFIX}"/usr/sbin \
		$(usex userland_GNU "" "--program-prefix=g") \
		$(use_enable nls) \
		$(use_enable xattr)
}

src_install() {
	emake DESTDIR="${D}" install || die

	local p=$(usex userland_GNU "" "g")
	if [[ -z ${p} ]] ; then
		# a nasty yet required piece of baggage
		exeinto /etc
		doexe "${FILESDIR}"/rmt || die
	fi

	# autoconf looks for gtar before tar (in configure scripts), hence
	# in Prefix it is important that it is there, otherwise, a gtar from
	# the host system (FreeBSD, Solaris, Darwin) will be found instead
	# of the Prefix provided (GNU) tar
	if use prefix ; then
		dosym tar /bin/gtar
	fi

	dodoc AUTHORS ChangeLog* NEWS README* THANKS
	newman "${FILESDIR}"/tar.1 ${p}tar.1
	mv "${ED}"/usr/sbin/${p}backup{,-tar}
	mv "${ED}"/usr/sbin/${p}restore{,-tar}

	if use minimal ; then
		find "${ED}"/etc "${ED}"/*bin/ "${ED}"/usr/*bin/ \
			-type f -a '!' '(' -name tar -o -name ${p}tar ')' \
			-delete
	fi
}
