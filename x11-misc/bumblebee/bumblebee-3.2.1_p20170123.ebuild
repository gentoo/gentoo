# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools readme.gentoo-r1 multilib systemd user

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://github.com/Bumblebee-Project/Bumblebee.git"
	EGIT_BRANCH="develop"
else
	COMMIT="c322bd849aabe6e48b4304b8d13cc4aadc36a30d"
	SRC_URI="https://github.com/Bumblebee-Project/Bumblebee/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	S="${WORKDIR}/Bumblebee-${COMMIT}"
fi

DESCRIPTION="Service providing elegant and stable means of managing Optimus graphics chipsets"
HOMEPAGE="http://bumblebee-project.org https://github.com/Bumblebee-Project/Bumblebee"

SLOT="0"
LICENSE="GPL-3"

IUSE="+bbswitch video_cards_nouveau video_cards_nvidia"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/libbsd
	sys-apps/kmod
	x11-libs/libX11
"

RDEPEND="${COMMON_DEPEND}
	virtual/opengl
	x11-base/xorg-drivers[video_cards_nvidia?,video_cards_nouveau?]
	bbswitch? ( sys-power/bbswitch )
"

DEPEND="${COMMON_DEPEND}
	sys-apps/help2man
	virtual/pkgconfig
"

PDEPEND="
	|| (
		x11-misc/primus
		x11-misc/virtualgl
	)
"

REQUIRED_USE="|| ( video_cards_nouveau video_cards_nvidia )"

pkg_setup() {
	enewgroup bumblebee
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	DOC_CONTENTS="In order to use Bumblebee, add your user to 'bumblebee' group.
		You may need to setup your /etc/bumblebee/bumblebee.conf"

	if use video_cards_nvidia ; then
		# Get paths to GL libs for all ABIs
		local nvlib=""
		for i in  $(get_all_libdirs) ; do
			nvlib="${nvlib}:/usr/${i}/opengl/nvidia/lib"
		done

		local nvpref="/usr/$(get_libdir)/opengl/nvidia"
		local xorgpref="/usr/$(get_libdir)/xorg/modules"
		ECONF_PARAMS="CONF_DRIVER=nvidia CONF_DRIVER_MODULE_NVIDIA=nvidia \
			CONF_LDPATH_NVIDIA=${nvlib#:} \
			CONF_MODPATH_NVIDIA=${nvpref}/lib,${nvpref}/extensions,${xorgpref}/drivers,${xorgpref}"
	fi

	econf \
		--docdir=/usr/share/doc/"${PF}" \
		${ECONF_PARAMS}
}

src_install() {
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newenvd "${FILESDIR}"/${PN}.envd 99${PN}
	systemd_dounit scripts/systemd/bumblebeed.service

	readme.gentoo_create_doc

	default
}
#
#pkg_preinst() {
#	use video_cards_nvidia || rm "${ED}"/etc/bumblebee/xorg.conf.nvidia
#	use video_cards_nouveau || rm "${ED}"/etc/bumblebee/xorg.conf.nouveau
#}
