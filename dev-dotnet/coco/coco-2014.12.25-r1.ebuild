# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream did not tag this release.
if [[ "${PV}" == "2014.12.25" ]] ; then
	COMMIT_SHA="14be0314ae393569ab7abaf4e187f78e6d42b2fd"
else
	die 'Could not detect "COMMIT_SHA", please update the ebuild.'
fi

DOTNET_PKG_COMPAT="10.0"
NUGET_PACKAGES=""

inherit dotnet-pkg

DESCRIPTION="The compiler generator Coco/R for C#"
HOMEPAGE="https://github.com/boogie-org/coco/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/boogie-org/${PN}.git"
else
	SRC_URI="https://github.com/boogie-org/${PN}/archive/${COMMIT_SHA}.tar.gz
		-> ${P}.snapshot.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"

	KEYWORDS="amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

DOTNET_PKG_PROJECTS=( Coco.csproj )

dotnet-pkg_force-compat

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}
