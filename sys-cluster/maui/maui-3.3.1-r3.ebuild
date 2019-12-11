# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils multilib

DESCRIPTION="Maui Cluster Scheduler"
HOMEPAGE="http://www.adaptivecomputing.com/products/open-source/maui/"
SRC_URI="http://www.adaptivecomputing.com/download/${PN}/${P}.tar.gz"

LICENSE="maui"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="pbs slurm"

REQUIRED_USE="^^ ( pbs slurm )"

DEPEND="
	pbs? ( >=sys-cluster/torque-4 )
	slurm? ( sys-cluster/slurm )"
RDEPEND="${DEPEND}"

RESTRICT="fetch mirror"

pkg_setup() {
	if use slurm; then
		if [ -z ${MAUI_KEY} ]; then
			eerror "You should set MAUI_KEY to any integer value in make.conf"
			return 1
		fi
	fi
}

src_prepare() {
	sed -e "s:\$(INST_DIR)/lib:\$(INST_DIR)/$(get_libdir):" \
		-i src/{moab,server,mcom}/Makefile || die

	epatch "${FILESDIR}"/${P}-torque_4.patch
}

src_configure() {
	local myconf
	use pbs && myconf="--with-pbs=${EPREFIX}/usr"
	use slurm && myconf+=" --with-wiki --with-key=${MAUI_KEY}"
	econf \
		--with-spooldir="${EPREFIX}"/var/spool/${PN} \
		${myconf}
}

src_install() {
	emake BUILDROOT="${D}" INST_DIR="${ED}/usr" install
	dodoc docs/README CHANGELOG
	dohtml docs/mauidocs.html
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}, obtain the file"
	einfo "${P}.tar.gz and put it in your DISTDIR directory."
}
