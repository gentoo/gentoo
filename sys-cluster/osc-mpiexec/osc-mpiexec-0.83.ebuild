# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PN=${PN#osc-}
DESCRIPTION="replacement for mpirun, integrates MPI with PBS"
SRC_URI="http://www.osc.edu/~djohnson/mpiexec/${MY_PN}-${PV}.tgz"
HOMEPAGE="http://www.osc.edu/~djohnson/mpiexec/index.php"

DEPEND="sys-cluster/torque"
RDEPEND="${DEPEND}
	net-misc/openssh"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

S="${WORKDIR}"/${MY_PN}-${PV}

RESTRICT="test"
# The test suite that is included with the source requires
# the ability to qsub a number of jobs.  Such behavior
# obviously does not belong in the ebuild.

src_compile() {
	local c="--with-default-comm=mpich-p4
		--with-pbs=/usr/
		--with-mpicc=/usr/bin/mpicc
		--with-mpif77=/usr/bin/mpif77"

	# The following at the recommendation of README, Cray specific.
	c="${c} --disable-mpich-rai"

	econf ${c} || die
	emake || die "compile failed"
}

src_install() {
	local f
	emake DESTDIR="${D}" install || die

	# And the following so that osc-mpiexec doesn't conflict with
	# the packaged mpiexec's that all the MPI-2 implementations have.
	for f in $(find "${D}" -name 'mpiexec*'); do
		mv ${f} $(dirname ${f})/osc-$(basename ${f}) \
			|| die "Failed to prefix binary ${f} with osc-"
	done

	dodoc README README.lam ChangeLog
}

pkg_postinst() {
	elog "The OSC Mpiexec package typically installs it's binaries"
	elog "and manpages as 'mpiexec'.  However, this ebuild renames"
	elog "those to be prefixed with 'osc-' in order to avoid blocking"
	elog "against the exact packages that osc-mpiexec is meant to"
	elog "work with."
	elog
	elog "The default communication device has been set to mpich-p4"
	elog "(ethernet).  If you wish to use another communication"
	elog "device, either set MPIEXEC_COMM in your environment or use"
	elog "the --comm argument to mpiexec."
}
