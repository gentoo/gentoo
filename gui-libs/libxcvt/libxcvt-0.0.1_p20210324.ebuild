# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

# When COMMIT is defined, this ebuild turns from a release into a snapshot ebuild:
COMMIT="81747a3d1270edb4d9df8f133206914512f604fe"

DESCRIPTION="A standalone version of the X server implementation of the VESA CVT standard timing modelines generator"
HOMEPAGE="https://gitlab.freedesktop.org/ofourdan/libxcvt"
if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/ofourdan/${PN}"
else
	if [[ -n ${COMMIT} ]]; then
		SRC_URI="https://gitlab.freedesktop.org/ofourdan/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${COMMIT}
# There are no tagged releases, so any SRC_URI would be just a guess
#	else
#		SRC_URI="https://freedesktop.org/software/${PN}/releases/${P}.tar.xz"
	fi
	# Code originally from x11-base/xorg-server, so it makes sense to re-use its keywords
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"

SLOT="0"

COMMON_DEPEND="virtual/libc"

RDEPEND="
	${COMMON_DEPEND}
	|| (
		x11-base/xorg-server[-xorg]
		x11-base/xorg-server[minimal]
		!x11-base/xorg-server
	)
"

DEPEND="${COMMON_DEPEND}"
