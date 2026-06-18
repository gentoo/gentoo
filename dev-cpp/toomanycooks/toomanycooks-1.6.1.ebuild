# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++20 concurrency framework with no compromises"
HOMEPAGE="https://github.com/tzcnt/TooManyCooks"

MY_PN=TooManyCooks
SRC_URI="https://github.com/tzcnt/TooManyCooks/archive/refs/tags/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

# NOTE: Dependents MUST add this package's DEPENDs as RDEPENDs, to ensure SLOT
#       rebuilds function correctly.
#
# NOTE: While sys-apps/hwloc is technically optional, it's highly desireable
#       and avoids having to propagate a conditional dependency specification
#       to its dependents. Solving bug #680496 wouldn't be sufficient, as this
#       still wouldn't solve SLOT rebuilds.

DEPEND="
	sys-apps/hwloc:=
"

src_install() {
	cmake_src_install

	# Remove license file from weird location. It's included in the gentoo repository.
	rm -r "${ED}/usr/licenses" || die
}
