# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/hylafaxplus/hylafaxplus-5.5.4-r1.ebuild,v 1.5 2014/08/10 20:44:19 slyfox Exp $

EAPI="5"

inherit eutils multilib pam toolchain-funcs

MY_PN="${PN/plus/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enterprise client-server fax package for class 1 and 2 fax modems"
HOMEPAGE="http://hylafax.sourceforge.net"
SRC_URI="mirror://sourceforge/hylafax/${MY_P}.tar.gz"

SLOT="0"
LICENSE="hylafaxplus"
KEYWORDS="amd64 x86"

IUSE="jbig html ldap mgetty pam"

DEPEND=">=sys-libs/zlib-1.1.4
	app-text/ghostscript-gpl
	virtual/mta
	media-libs/tiff[jbig?]
	virtual/jpeg
	jbig? ( media-libs/jbigkit )
	virtual/awk
	ldap? (  net-nds/openldap )
	pam? ( virtual/pam )
	mgetty? ( net-dialup/mgetty[-fax] )"

RDEPEND="${DEPEND}
	net-mail/metamail
	!net-dialup/sendpage"

S="${WORKDIR}/${MY_P}"

export CONFIG_PROTECT="${CONFIG_PROTECT} /var/spool/fax/etc /usr/lib/fax"

src_prepare() {
	epatch "${FILESDIR}/ldconfig-patch"
	epatch "${FILESDIR}/hylafax-cryptglibc.patch"

	# force it not to strip binaries
	for dir in etc util faxalter faxcover faxd faxmail faxrm faxstat \
		hfaxd sendfax sendpage ; do
			sed -i -e "s:-idb:-idb \"nostrip\" -idb:g" \
				"${dir}"/Makefile.in || die "sed failed"
	done

	sed -i -e "s:hostname:hostname -f:g" util/{faxrcvd,pollrcvd}.sh.in || die "sed on hostname failed"

	# Respect LDFLAGS(at least partially)
	sed -i -e "/^LDFLAGS/s/LDOPTS}/LDOPTS} ${LDFLAGS}/" defs.in || die "sed on defs.in failed"

	sed -i -e "s|-fpic|-fPIC|g" \
		configure || die

	epatch_user
}

src_configure() {
	do_configure() {
		echo ./configure --nointeractive ${1}
		# eval required for quoting in ${my_conf} to work properly, better way?
		eval ./configure --nointeractive ${1} || die "./configure failed"
	}
	local my_conf="
		--with-DIR_BIN=/usr/bin
		--with-DIR_SBIN=/usr/sbin
		--with-DIR_LIB=/usr/$(get_libdir)
		--with-DIR_LIBEXEC=/usr/sbin
		--with-DIR_LIBDATA=/usr/$(get_libdir)/fax
		--with-DIR_LOCALE=/usr/share/locale
		--with-DIR_LOCKS=/var/lock
		--with-DIR_MAN=/usr/share/man
		--with-DIR_SPOOL=/var/spool/fax
		--with-DIR_HTML=/usr/share/doc/${P}/html
		--with-DIR_CGI="${WORKDIR}"
		--with-PATH_DPSRIP=/var/spool/fax/bin/ps2fax
		--with-PATH_IMPRIP=\"\"
		--with-SYSVINIT=no
		--with-REGEX=yes
		--with-LIBTIFF=\"-ltiff -ljpeg -lz\"
		--with-OPTIMIZER=\"${CFLAGS}\"
		--with-DSO=auto
		--with-HTML=$(usex html)"

	if use mgetty; then
		my_conf="${my_conf} \
			--with-PATH_GETTY=/sbin/mgetty \
			--with-PATH_EGETTY=/sbin/mgetty \
			--with-PATH_VGETTY=/usr/sbin/vgetty"
	else
		# GETTY defaults to /sbin/agetty
		my_conf="${my_conf} \
			--with-PATH_EGETTY=/bin/false \
			--with-PATH_VGETTY=/bin/false"
	fi

	#--enable-pam isn't valid
	use pam || my_conf="${my_conf} $(use_enable pam)"
	use ldap || my_conf="${my_conf} $(use_enable ldap)"
	use jbig || my_conf="${my_conf} $(use_enable jbig)"

	tc-export CC CXX AR RANLIB

	do_configure "${my_conf}"
}

src_compile() {
	# Parallel building is borked
	emake -j1
}

src_install() {
	dodir /usr/{bin,sbin} /usr/$(get_libdir)/fax /usr/share/man
	dodir /var/spool /var/spool/recvq /var/spool/fax
	fowners uucp:uucp /var/spool/fax
	fperms 0600 /var/spool/fax
	dodir "/usr/share/doc/${P}/samples"

	emake DESTDIR="${D}" \
		BIN="${D}/usr/bin" \
		SBIN="${D}/usr/sbin" \
		LIBDIR="${D}/usr/$(get_libdir)" \
		LIB="${D}/usr/$(get_libdir)" \
		LIBEXEC="${D}/usr/sbin" \
		LIBDATA="${D}/usr/$(get_libdir)/fax" \
		DIR_LOCALE="${D}/usr/share/locale" \
		MAN="${D}/usr/share/man" \
		SPOOL="${D}/var/spool/fax" \
		HTMLDIR="${D}/usr/share/doc/${PF}/html" \
		install

	keepdir /var/spool/fax/{archive,client,etc,pollq,recvq,tmp}
	keepdir /var/spool/fax/{status,sendq,log,info,doneq,docq,dev}

	generate_files # in this case, it only generates the env.d entry

	einfo "Adding env.d entry for ${PN}"
	doenvd "${T}/99${PN}"

	newconfd "${FILESDIR}/${PN}-conf" ${PN}
	newinitd "${FILESDIR}/${PN}-init" ${PN}

	use pam && pamd_mimic_system ${MY_PN} auth account session

	dodoc CONTRIBUTORS README TODO
	docinto samples
}

pkg_postinst() {
	elog
	elog "The faxonly USE flag has been removed; since ${PN} does not"
	elog "require mgetty, and certain fax files conflict, you must build"
	elog "mgetty without fax support if you wish to use them both.  You"
	elog "may want to add both to package.use so any future updates are"
	elog "correctly built:"
	elog
	elog "	net-dialup/mgetty -fax"
	elog "	net-misc/hylafax [-mgetty|mgetty]"
	elog
	elog "See the docs and man pages for detailed configuration info."
	elog
	elog "Now run faxsetup and (if necessary) faxaddmodem."
	elog
}

generate_files() {
	cat <<-EOF > "${T}/99${PN}"
	PATH="/var/spool/fax/bin"
	CONFIG_PROTECT="/var/spool/fax/etc /usr/$(get_libdir)/fax"
	EOF
}
