# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic pam python-single-r1 linux-info autotools

DESCRIPTION="eCryptfs userspace utilities"
HOMEPAGE="https://launchpad.net/ecryptfs"
SRC_URI="https://dev.gentoo.org/~bkohler/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc gpg gtk nls openssl pam pkcs11 python suid tpm"

RDEPEND=">=sys-apps/keyutils-1.5.11-r1:=
	>=dev-libs/libgcrypt-1.2.0:0
	dev-libs/nss
	gpg? ( app-crypt/gpgme )
	gtk? ( x11-libs/gtk+:2 )
	openssl? ( >=dev-libs/openssl-0.9.7:= )
	pam? ( sys-libs/pam )
	pkcs11? (
		>=dev-libs/openssl-0.9.7:=
		>=dev-libs/pkcs11-helper-1.04
	)
	python? ( ${PYTHON_DEPS} )
	tpm? ( app-crypt/trousers )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.41.0
	python? ( dev-lang/swig )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup

	CONFIG_CHECK="~ECRYPT_FS"
	linux-info_pkg_setup
}

src_unpack() {
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/${P}.tar.gz" --strip-components=3 -C "${S}"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags -D_FILE_OFFSET_BITS=64

	econf \
		--enable-nss \
		--with-pamdir=$(getpam_mod_dir) \
		$(use_enable doc docs) \
		$(use_enable gpg) \
		$(use_enable gtk gui) \
		$(use_enable nls) \
		$(use_enable openssl) \
		$(use_enable pam) \
		$(use_enable pkcs11 pkcs11-helper) \
		$(use_enable python pywrap) \
		$(use_enable tpm tspi)
}

src_install() {
	emake DESTDIR="${D}" install

	if use python; then
		echo "ecryptfs-utils" > "${D}$(python_get_sitedir)/ecryptfs-utils.pth" || die
	fi

	use suid && fperms u+s /sbin/mount.ecryptfs_private

	find "${ED}" -name '*.la' -exec rm -f '{}' + || die
}

pkg_postinst() {
	if use suid; then
		ewarn
		ewarn "You have chosen to install ${PN} with the binary setuid root. This"
		ewarn "means that if there are any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
		ewarn
	fi
}
