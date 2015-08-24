# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils pam systemd

DESCRIPTION="An open source Remote Desktop Protocol server"
HOMEPAGE="http://www.xrdp.org/"
# mirrored from https://github.com/neutrinolabs/xrdp/releases
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fuse kerberos jpeg pam pulseaudio"

RDEPEND="dev-libs/openssl:0=
	x11-libs/libX11:0=
	x11-libs/libXfixes:0=
	x11-libs/libXrandr:0=
	fuse? ( sys-fs/fuse:0= )
	jpeg? ( virtual/jpeg:0= )
	kerberos? ( virtual/krb5:0= )
	pam? ( virtual/pam:0= )
	pulseaudio? ( media-sound/pulseaudio:0= )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"
RDEPEND="${RDEPEND}
	|| (
		net-misc/tigervnc:0=[server,xorgmodule]
		net-misc/x11rdp:0=
	)"

# does not work with gentoo version of freerdp
#	neutrinordp? ( net-misc/freerdp:0= )
# incompatible with current ffmpeg/libav (surprising, isn't it?)
#	xrdpvr? ( virtual/ffmpeg:0= )

src_prepare() {
	epatch_user

	# #540630: crypt() unchecked for NULL return
	epatch "${FILESDIR}"/${P}-crypt-null-return.patch

	# don't let USE=debug adjust CFLAGS
	sed -i -e 's:-g -O0::' configure.ac || die
	# disallow root login by default
	sed -i -e '/^AllowRootLogin/s/1/0/' sesman/sesman.ini || die
	# Fedora files, not included here
	sed -i -e '/EnvironmentFile=/d' instfiles/*.service || die
	# reorder so that X11rdp comes last again since it's not supported
	sed -i -e '/^\[xrdp1\]$/,/^$/{wxrdp.ini.tmp
		;d}' xrdp/xrdp.ini || die
	# move newline to the beginning
	sed -i -e 'x' xrdp.ini.tmp || die
	cat xrdp.ini.tmp >> xrdp/xrdp.ini || die
	rm -f xrdp.ini.tmp || die

	eautoreconf
	# part of ./bootstrap
	ln -s ../config.c sesman/tools/config.c || die
}

src_configure() {
	use kerberos && use pam \
		&& ewarn "Both kerberos & pam auth enabled, kerberos will take precedence."

	local myconf=(
		# warning: configure.ac is completed flawed

		--localstatedir="${EPREFIX}"/var

		# -- authentication backends --
		# kerberos is inside !SESMAN_NOPAM conditional for no reason
		$(use pam || use kerberos || echo --enable-nopam)
		$(usex kerberos --enable-kerberos '')
		# pam_userpass is not in Gentoo at the moment
		#--disable-pamuserpass

		# -- jpeg support --
		$(usex jpeg --enable-jpeg '')
		# the package supports explicit linking against libjpeg-turbo
		# (no need for -ljpeg compat)
		$(use jpeg && has_version 'media-libs/libjpeg-turbo:0' && echo --enable-tjpeg)

		# -- sound support --
		$(usex pulseaudio '--enable-simplesound --enable-loadpulsemodules' '')

		# -- others --
		$(usex debug --enable-xrdpdebug '')
		$(usex fuse --enable-fuse '')
		# $(usex neutrinordp --enable-neutrinordp '')
		# $(usex xrdpvr --enable-xrdpvr '')

		"$(systemd_with_unitdir)"
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	prune_libtool_files --all

	# use our pam.d file since upstream's incompatible with Gentoo
	use pam && newpamd "${FILESDIR}"/xrdp-sesman.pamd xrdp-sesman
	# and our startwm.sh
	exeinto /etc/xrdp
	doexe "${FILESDIR}"/startwm.sh

	# Fedora stuff
	rm -r "${ED}"/etc/default || die

	# own /etc/xrdp/rsakeys.ini
	: > rsakeys.ini
	insinto /etc/xrdp
	doins rsakeys.ini

	# contributed by Jan Psota <jasiupsota@gmail.com>
	newinitd "${FILESDIR}/${PN}-initd" ${PN}
}

pkg_preinst() {
	# either copy existing keys over to avoid CONFIG_PROTECT whining
	# or generate new keys (but don't include them in binpkg!)
	if [[ -f ${EROOT}/etc/xrdp/rsakeys.ini ]]; then
		cp {"${EROOT}","${ED}"}/etc/xrdp/rsakeys.ini || die
	else
		einfo "Running xrdp-keygen to generate new rsakeys.ini ..."
		"${S}"/keygen/xrdp-keygen xrdp "${ED}"/etc/xrdp/rsakeys.ini \
			|| die "xrdp-keygen failed to generate RSA keys"
	fi
}

pkg_postinst() {
	# check for use of bundled rsakeys.ini (installed by default upstream)
	if [[ $(cksum "${EROOT}"/etc/xrdp/rsakeys.ini) == '2935297193 1019 '* ]]
	then
		ewarn "You seem to be using upstream bundled rsakeys.ini. This means that"
		ewarn "your communications are encrypted using a well-known key. Please"
		ewarn "consider regenerating rsakeys.ini using the following command:"
		ewarn
		ewarn "  ${EROOT}/usr/bin/xrdp-keygen xrdp ${EROOT}/etc/xrdp/rsakeys.ini"
		ewarn
	fi

	elog "Various session types require different backend implementations:"
	elog "- sesman-Xvnc requires net-misc/tigervnc[server,xorgmodule]"
	elog "- sesman-X11rdp requires net-misc/x11rdp"
}
