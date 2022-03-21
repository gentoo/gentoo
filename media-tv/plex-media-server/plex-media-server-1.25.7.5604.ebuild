# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 systemd unpacker

MY_PV="${PV}-980a13e02"
MY_URI="https://downloads.plex.tv/plex-media-server-new"

DESCRIPTION="Free media library that is intended for use with a plex client"
HOMEPAGE="https://www.plex.tv/"
SRC_URI="
	amd64? ( ${MY_URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_amd64.deb )
	x86? ( ${MY_URI}/${MY_PV}/debian/plexmediaserver_${MY_PV}_i386.deb )"
S="${WORKDIR}"

LICENSE="Plex"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror bindist"

DEPEND="
	acct-group/plex
	acct-user/plex"
RDEPEND="${DEPEND}"

QA_PREBUILT="*"
QA_MULTILIB_PATHS=(
	"usr/lib/plexmediaserver/lib/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload/_hashlib.so"
)

src_install() {
	# Remove Debian specific files
	rm -r "usr/share/doc" || die

	# Add startup wrapper
	dosbin "${FILESDIR}/start_pms"

	# Add user config file
	mkdir -p "${ED}/etc/default" || die
	cp usr/lib/plexmediaserver/lib/plexmediaserver.default "${ED}"/etc/default/plexmediaserver || die

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}" || die

	# Make sure the logging directory is created
	keepdir /var/log/pms
	fowners plex:plex /var/log/pms

	keepdir /var/lib/plexmediaserver
	fowners plex:plex /var/lib/plexmediaserver

	newinitd usr/lib/plexmediaserver/lib/plexmediaserver.init "${PN}"

	systemd_dounit "${ED}"/usr/lib/plexmediaserver/lib/plexmediaserver.service
	keepdir /var/lib/plexmediaserver

	# Adds the precompiled plex libraries to the revdep-rebuild's mask list
	# so it doesn't try to rebuild libraries that can't be rebuilt.
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/80plexmediaserver

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
