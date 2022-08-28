# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs vdr-plugin-2

DESCRIPTION="VDR Plugin: Client/Server and http streaming plugin"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-streamdev"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-streamdev/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-streamdev-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="client +server"
REQUIRED_USE="|| ( client server )"

DEPEND="acct-user/vdr
	>=media-video/vdr-2.3"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-streamdev-.*
	usr/lib64/vdr/plugins/libvdr-streamdev-.*"
PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )

# vdr-plugin-2.eclass changes
PO_SUBDIR="client server"

src_prepare() {
	# make detection in vdr-plugin-2.eclass for new Makefile handling happy
	echo "# SOFILE" >> Makefile || die "modify Makefile failed"

	# remove unnecessary include
	sed -i Makefile -e "s:-I\$(VDRDIR)/include::" || die "modify Makefile failed"

	vdr-plugin-2_src_prepare

	local flag
	for flag in client server; do
		if ! use ${flag}; then
			sed -i Makefile \
				-e '/^.PHONY:/s/'${flag}'//' \
				-e '/^.PHONY:/s/'install-${flag}'//' \
				-e '/^all:/s/'${flag}'//' \
				-e '/^install:/s/'install-${flag}'//' || die "modify Makefile failed"
		fi
	done

	fix_vdr_libsi_include server/livestreamer.c
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	vdr-plugin-2_src_install

	if use server; then
		insinto /usr/share/vdr/streamdev
		doins streamdev-server/externremux.sh

		insinto /usr/share/vdr/rcscript
		newins "${FILESDIR}"/rc-addon-0.6.0.sh plugin-streamdev-server.sh

		newconfd "${FILESDIR}"/confd-0.6.0 vdr.streamdev-server

		insinto /etc/vdr/plugins/streamdev-server
		newins streamdev-server/streamdevhosts.conf streamdevhosts.conf
		fowners vdr:vdr /etc/vdr -R
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	if [[ -e "${EROOT}"/etc/vdr/plugins/streamdev/streamdevhosts.conf ]]; then
		einfo "move config file to new config DIR ${EROOT}/etc/vdr/plugins/streamdev-server/"
		mv "${EROOT}"/etc/vdr/plugins/streamdev/streamdevhosts.conf "${EROOT}"/etc/vdr/plugins/streamdev-server/streamdevhosts.conf || die
	fi
}
