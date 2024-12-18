# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# note: not "required" but should typically be bumped at same
# time as pcsx2 to match the patches.zip shipped with it

PYTHON_COMPAT=( python3_{10..13} )
inherit python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PCSX2/pcsx2_patches.git"
else
	HASH_PCSX2_PATCHES=
	SRC_URI="
		https://github.com/PCSX2/pcsx2_patches/archive/${HASH_PCSX2_PATCHES}.tar.gz
			-> ${P}.tar.gz
	"
	S=${WORKDIR}/${PN}-${HASH_PCSX2_PATCHES}
	KEYWORDS="~amd64"
fi

DESCRIPTION="Collection of game patches for use with PCSX2 (e.g. widescreen hacks)"
HOMEPAGE="https://github.com/PCSX2/pcsx2_patches/"

# these are normally distributed by upstream with PCSX2 which is GPL-3+
LICENSE="GPL-3+"
SLOT="0"

BDEPEND="${PYTHON_DEPS}"

src_compile() {
	# upstream uses a constantly replaced "latest" patches.zip (currently no
	# real releases), and github's .zip archives cannot be used either due to
	# having the patches/ subdirectory -- so we use a snapshot and repack
	# (could use app-arch/zip, but python is more likely to skip a dependency)
	ebegin "Creating patches.zip"
	"${PYTHON}" - <<-EOF
		import pathlib
		from zipfile import ZipFile, ZIP_DEFLATED

		patches = pathlib.Path("patches/")

		with ZipFile("patches.zip", "w", ZIP_DEFLATED, compresslevel=9) as archive:
		    for file in patches.iterdir():
		        archive.write(file, arcname=file.name)
	EOF
	eend ${?} || die
}

src_install() {
	insinto /usr/share/PCSX2/resources
	doins patches.zip

	einstalldocs
}
