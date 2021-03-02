# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam toolchain-funcs

MY_PN="${PN/plus/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enterprise client-server fax package for class 1 and 2 fax modems"
HOMEPAGE="http://hylafax.sourceforge.net"
SRC_URI="mirror://sourceforge/hylafax/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="hylafaxplus"
KEYWORDS="~amd64 ~x86"
IUSE="html jbig lcms ldap mgetty pam"

DEPEND="
	app-text/ghostscript-gpl
	media-libs/tiff:0[jbig?]
	!net-dialup/mgetty[fax]
	>=sys-libs/zlib-1.1.4
	virtual/awk
	virtual/jpeg:0
	virtual/mta
	jbig? ( media-libs/jbigkit )
	lcms? ( media-libs/lcms )
	ldap? (  net-nds/openldap )
	mgetty? ( net-dialup/mgetty[-fax] )
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}
	!net-dialup/sendpage
	net-mail/metamail
"

CONFIG_PROTECT="${CONFIG_PROTECT} /var/spool/fax/etc /usr/lib/fax"
CONFIG_PROTECT_MASK="${CONFIG_PROTECT_MASK} /var/spool/fax/etc/xferfaxlog"

PATCHES=(
	"${FILESDIR}/ldconfig-patch"
	"${FILESDIR}"/${PN}-7.0.2-tiff-4.2.patch
)

src_prepare() {
	default

	# force it not to strip binaries
	for dir in etc util faxalter faxcover faxd faxmail faxrm faxstat \
		hfaxd sendfax sendpage ; do
			sed -i -e "s:-idb:-idb \"nostrip\" -idb:g" \
				"${dir}"/Makefile.in || die "sed on ${dir}/Makefile.in failed"
	done

	sed -i -e "s:hostname:hostname -f:g" util/{faxrcvd,pollrcvd}.sh.in || die "sed on hostname failed"

	# Respect LDFLAGS(at least partially)
	sed -i -e "/^LDFLAGS/s/LDOPTS}/LDOPTS} ${LDFLAGS}/" defs.in || die "sed on defs.in failed"

	sed -i -e "s|-fpic|-fPIC|g" \
		configure || die
}

src_configure() {
	do_configure() {
		echo ./configure --nointeractive ${1}
		# eval required for quoting in ${my_conf} to work properly, better way?
		eval ./configure --nointeractive ${1} || die "./configure failed"
	}

	local my_conf=(
		--with-DIR_BIN=/usr/bin
		--with-DIR_SBIN=/usr/sbin
		--with-DIR_LIB=/usr/$(get_libdir)
		--with-DIR_LIBEXEC=/usr/sbin
		--with-DIR_LIBDATA=/usr/$(get_libdir)/fax
		--with-DIR_LOCALE=/usr/share/locale
		--with-DIR_LOCKS=/var/lock
		--with-DIR_MAN=/usr/share/man
		--with-DIR_SPOOL=/var/spool/fax
		--with-DIR_HTML=/usr/share/doc/${PF}/html
		--with-DIR_CGI="${WORKDIR}"
		--with-PATH_DPSRIP=/var/spool/fax/bin/ps2fax
		--with-PATH_IMPRIP=""
		--with-SYSVINIT=no
		--with-REGEX=yes
		--with-LIBTIFF=\"-ltiff -ljpeg -lz\"
		--with-OPTIMIZER=\"${CFLAGS}\"
		--with-DSO=auto
		--with-HTML=$(usex html)
	)

	if use mgetty; then
		my_conf+=(
			--with-PATH_GETTY=/sbin/mgetty
			--with-PATH_EGETTY=/sbin/mgetty
			--with-PATH_VGETTY=/usr/sbin/vgetty
		)
	else
		# GETTY defaults to /sbin/agetty
		my_conf+=(
			--with-PATH_EGETTY=/bin/false
			--with-PATH_VGETTY=/bin/false
		)
	fi

	#--enable-pam isn't valid
	use pam || my_conf+=( $(use_enable pam) )
	use lcms || my_conf+=( $(use_enable lcms) )
	use ldap || my_conf+=( $(use_enable ldap) )
	use jbig || my_conf+=( $(use_enable jbig) )

	tc-export CC CXX AR RANLIB

	do_configure "${my_conf[*]}"
}

src_compile() {
	# Parallel building is borked, bug #????
	emake -j1
}

src_install() {
	dodir /usr/{bin,sbin} /usr/$(get_libdir)/fax /usr/share/man
	dodir /var/spool /var/spool/fax
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

	einfo "Adding env.d entry for ${PN}"
	newenvd - 99hylafaxplus <<-EOF
		PATH="/var/spool/fax/bin"
		CONFIG_PROTECT="/var/spool/fax/etc /usr/$(get_libdir)/fax"
		CONFIG_PROTECT_MASK="/var/spool/fax/etc/xferfaxlog"
	EOF

	newconfd "${FILESDIR}/${PN}-conf" ${PN}
	newinitd "${FILESDIR}/${PN}-init" ${PN}

	use pam && pamd_mimic_system ${MY_PN} auth account session

	einstalldocs
	docinto samples
}
