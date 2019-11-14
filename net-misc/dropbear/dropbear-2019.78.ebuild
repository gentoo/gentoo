# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig pam user

DESCRIPTION="small SSH 2 client/server designed for small memory environments"
HOMEPAGE="https://matt.ucc.asn.au/dropbear/dropbear.html"
SRC_URI="https://matt.ucc.asn.au/dropbear/releases/${P}.tar.bz2
	https://matt.ucc.asn.au/dropbear/testing/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="bsdpty minimal multicall pam +shadow static +syslog zlib"

LIB_DEPEND="zlib? ( sys-libs/zlib[static-libs(+)] )
	dev-libs/libtommath[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
RDEPEND+=" pam? ( >=sys-auth/pambase-20080219.1 )"

REQUIRED_USE="pam? ( !static )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.46-dbscp.patch
)

set_options() {
	progs=(
		dropbear dbclient dropbearkey
		$(usex minimal "" "dropbearconvert scp")
	)
	makeopts=(
		MULTI=$(usex multicall 1 0)
	)
}

src_prepare() {
	default
	sed \
		-e '/SFTPSERVER_PATH/s:".*":"/usr/lib/misc/sftp-server":' \
		default_options.h > localoptions.h || die
	sed \
		-e '/pam_start/s:sshd:dropbear:' \
		-i svr-authpam.c || die
	restore_config localoptions.h
}

src_configure() {
	# XXX: Need to add libtomcrypt to the tree and re-enable this.
	#	--disable-bundled-libtom
	# We disable the hardening flags as our compiler already enables them
	# by default as is appropriate for the target.
	local myeconfargs=(
		--disable-harden
		$(use_enable zlib)
		$(use_enable pam)
		$(use_enable !bsdpty openpty)
		$(use_enable shadow)
		$(use_enable static)
		$(use_enable syslog)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	set_options
	emake "${makeopts[@]}" PROGRAMS="${progs[*]}"
}

src_install() {
	set_options
	emake "${makeopts[@]}" PROGRAMS="${progs[*]}" DESTDIR="${D}" install
	doman *.8
	newinitd "${FILESDIR}"/dropbear.init.d dropbear
	newconfd "${FILESDIR}"/dropbear.conf.d dropbear
	dodoc CHANGES README SMALL MULTI

	# The multi install target does not install the links right.
	if use multicall ; then
		cd "${ED}"/usr/bin || die
		local x
		for x in "${progs[@]}" ; do
			ln -sf dropbearmulti ${x} || die "ln -s dropbearmulti to ${x} failed"
		done
		rm -f dropbear
		dodir /usr/sbin
		dosym ../bin/dropbearmulti /usr/sbin/dropbear
		cd "${S}" || die
	fi
	save_config localoptions.h

	if ! use minimal ; then
		mv "${ED}"/usr/bin/{,db}scp || die
	fi

	pamd_mimic system-remote-login dropbear auth account password session
}

pkg_preinst() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd
}
