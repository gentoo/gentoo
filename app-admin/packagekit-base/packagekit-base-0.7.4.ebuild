# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/packagekit-base/packagekit-base-0.7.4.ebuild,v 1.9 2014/07/24 17:42:36 ssuominen Exp $

EAPI="3"

# 0.7.x is untested with Python 3.x
PYTHON_DEPEND="2"

inherit eutils multilib python nsplugins bash-completion-r1

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Manage packages in a secure way using a cross-distro and cross-architecture API"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="connman cron doc +introspection networkmanager nsplugin pm-utils +policykit entropy static-libs test udev"

CDEPEND="connman? ( net-misc/connman )
	introspection? ( >=dev-libs/gobject-introspection-0.9.9 )
	networkmanager? ( >=net-misc/networkmanager-0.6.4 )
	nsplugin? (
		>=dev-libs/nspr-4.8
		x11-libs/cairo
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango
	)
	policykit? ( >=sys-auth/polkit-0.98 )
	udev? ( virtual/libgudev )
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.26.1:2
	>=sys-apps/dbus-1.3.0"
DEPEND="${CDEPEND}
	doc? ( dev-util/gtk-doc )
	nsplugin? ( <net-misc/npapi-sdk-0.27.1 )
	dev-libs/libxslt
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	sys-devel/gettext"

RDEPEND="${CDEPEND}
	entropy? ( >=sys-apps/entropy-1.0_rc27 )
	pm-utils? ( sys-power/pm-utils )
	>=app-portage/layman-1.2.3
	>=sys-apps/portage-2.1.9
	sys-auth/consolekit"

APP_LINGUAS="as bg bn ca cs da de el en_GB es fi fr gu he hi hu it ja kn ko ml mr
ms nb nl or pa pl pt pt_BR ro ru sk sr sr@latin sv ta te th tr uk zh_CN zh_TW"
for X in ${APP_LINGUAS}; do
	IUSE=" ${IUSE} linguas_${X}"
done

S="${WORKDIR}/${MY_P}"
RESTRICT="test" # tests are failing atm

# NOTES:
# do not use a specific user, useless and not more secure according to upstream
# doc is in the tarball and always installed
# mono doesn't install anything (RDEPEND dev-dotnet/gtk-sharp-gapi:2
#	(R)DEPEND dev-dotnet/glib-sharp:2 dev-lang/mono), upstream bug 23247
# >=npapi-sdk-0.27.1 has slightly changed API, once it is unmasked in tree
# drop the npapi-api-change patch below and relax the dependency constraints

# UPSTREAM:
# documentation/website with --enable-doc-install
# failing tests

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.x-npapi-sdk.patch #383141
	epatch "${FILESDIR}"/${PN}-0.7.x-npapi-api-change.patch #416711
	# http://pkgs.fedoraproject.org/gitweb/?p=PackageKit.git;a=commit;h=0b378668288db34890b82c7be007fc76c7fcd956
	sed -i -e '/polkit-backend-1/d' configure || die #423431
}

src_configure() {
	local myconf=""

	if use policykit; then
		myconf+=" --with-security-framework=polkit"
	else
		myconf+=" --with-security-framework=dummy"
	fi

	if [[ -z "${LINGUAS}" ]]; then
		myconf+=" --disable-nls"
	else
		myconf+=" --enable-nls"
	fi

	# localstatedir: for gentoo it's /var/lib but for $PN it's /var
	# dep-tracking,option-check,libtool-lock,strict,local: obvious reasons
	# command,debuginfo,gstreamer,service-packs: not supported by backend

	# NOTE: default backend is autodetected at runtime, also
	if use entropy; then
		myconf+=" --with-default-backend=entropy"
	else
		myconf+=" --with-default-backend=portage"
	fi
	econf \
		${myconf} \
		--enable-introspection=$(use introspection && echo -n "yes" || echo -n "no") \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--enable-option-checking \
		--enable-libtool-lock \
		--disable-strict \
		--disable-local \
		$(use_enable doc gtk-doc) \
		--enable-command-not-found \
		--disable-debuginfo-install \
		--disable-gstreamer-plugin \
		--disable-service-packs \
		--enable-man-pages \
		--enable-portage \
		$(use_enable entropy) \
		$(use_enable cron) \
		--disable-gtk-module \
		$(use_enable introspection) \
		$(use_enable networkmanager) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable connman) \
		$(use_enable pm-utils) \
		--disable-qt \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable udev device-rebind)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS MAINTAINERS NEWS README TODO || die "dodoc failed"
	dodoc ChangeLog || die "dodoc failed"

	if use nsplugin; then
		dodir "/usr/$(get_libdir)/${PLUGINS_DIR}"
		mv "${D}"/usr/$(get_libdir)/mozilla/plugins/* \
			"${D}/usr/$(get_libdir)/${PLUGINS_DIR}/"
	fi

	if ! use static-libs; then
		find "${D}" -name *.la | xargs rm || die "removing .la files failed"
	fi

	# Remove precompiled python modules, we handle byte compiling
	rm -f "${D}/$(python_get_sitedir)"/${PN}*.py[co]

	newbashcomp "${S}/contrib/pk-completion.bash" ${PN}
	# Remove bashcomp file installed by build-system
	rm -f "${D}/bash_completion.d/pk-completion.bash"

	# Remove unwanted PackageKit website stuff
	rm -rf "${D}/usr/share/PackageKit/website"

}

pkg_postinst() {
	python_mod_optimize ${PN/-base}

	if ! use policykit; then
		ewarn "You are not using policykit, the daemon can't be considered as secure."
		ewarn "All users will be able to do anything through ${MY_PN}."
		ewarn "Please, consider rebuilding ${MY_PN} with policykit USE flag."
		ewarn "THIS IS A SECURITY ISSUE."
		echo
	fi
}

pkg_prerm() {
	einfo "Removing downloaded files with ${MY_PN}..."
	[[ -d "${ROOT}"/var/cache/${MY_PN}/downloads/ ]] && \
		rm -rf /var/cache/PackageKit/downloads/*
}

pkg_postrm() {
	python_mod_cleanup ${PN/-base}
}
