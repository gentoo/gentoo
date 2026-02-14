# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Packages which get releases together:
# app-emacs/nxml-libvirt-schemas
# dev-python/libvirt-python
# dev-perl/Sys-Virt
# app-emulation/libvirt
# Please bump them together!

inherit elisp

MY_P="libvirt-${PV}"
DESCRIPTION="Extension for nxml-mode with libvirt schemas"
HOMEPAGE="https://www.libvirt.org/"
SRC_URI="https://download.libvirt.org/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P%-rc*}/src/conf/schemas"

# This is the license of the package, but the schema files are
# provided without license, maybe it's bad.
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64"

# Yes this requires Java, but I'd rather not repackage this, if you
# know something better in C, I'll be glad to use that.
BDEPEND="app-text/trang"

SITEFILE="60${PN}-gentoo.el"

src_compile() {
	emake -f - <<'EOF'
all: $(patsubst %.rng,%.rnc,$(wildcard *.rng))
%.rnc: %.rng
	trang -I rng -O rnc $< $@
EOF
}

src_install() {
	insinto "${SITEETC}/${PN}"
	doins "${FILESDIR}"/schemas.xml *.rnc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
