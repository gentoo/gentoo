# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Helper scripts useful for both OpenRC and systemd"
HOMEPAGE="https://packages.debian.org/sid/init-system-helpers"
# git repo: https://anonscm.debian.org/git/collab-maint/init-system-helpers.git
SRC_URI="http://http.debian.net/debian/pool/main/i/${PN}/${PN}_${PV}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND=">=dev-python/docutils-0.21.2"
RDEPEND="!<sys-apps/openrc-0.33"

PATCHES=(
	"${FILESDIR}/revert-openrc-management.patch"
)

src_install() {
	# We only care about 'service' script/manpage:
	exeinto /sbin/
	doexe script/service

	rst2man man8/service.rst > man8/service.8 || die "Failed to generate man page"

	# FIXME: need to patch to remove *rc.d references, which we don't ship
	# And should probably add a list of supported options (e.g., start/stop/etc.)
	doman man8/service.8
}
