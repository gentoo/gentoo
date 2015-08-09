# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils flag-o-matic multilib pam systemd toolchain-funcs versionator

MY_PV=$(delete_version_separator '_')
MY_P="${PN}-${MY_PV}"
PVER="20150503"

DESCRIPTION="The OpenAFS distributed file system"
HOMEPAGE="http://www.openafs.org/"
# We always d/l the doc tarball as man pages are not USE=doc material
[[ ${PV} == *_pre* ]] && MY_PRE="candidate/" || MY_PRE=""
SRC_URI="
	http://openafs.org/dl/openafs/${MY_PRE}${MY_PV}/${MY_P}-src.tar.bz2
	http://openafs.org/dl/openafs/${MY_PV}/${MY_P}-doc.tar.bz2
	http://dev.gentoo.org/~bircoph/patches/${PN}-patches-${PVER}.tar.xz
"

LICENSE="IBM BSD openafs-krb5-a APSL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~sparc ~x86 ~x86-linux"

IUSE="doc kerberos +modules pam"

CDEPEND="
	sys-libs/ncurses
	pam? ( sys-libs/pam )
	kerberos? ( virtual/krb5 )"

DEPEND="${CDEPEND}
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)"

RDEPEND="${CDEPEND}
	modules? ( ~net-fs/openafs-kernel-${PV} )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	EPATCH_EXCLUDE="050_all_job_server.patch" \
	EPATCH_SUFFIX="patch" \
	epatch "${WORKDIR}"/gentoo/patches
	epatch_user

	# fixing 2-nd level makefiles to honor flags
	sed -i -r 's/\<CFLAGS[[:space:]]*=/CFLAGS+=/; s/\<LDFLAGS[[:space:]]*=/LDFLAGS+=/' \
		src/*/Makefile.in || die '*/Makefile.in sed failed'

	# packaging is f-ed up, so we can't run eautoreconf
	# run autotools commands based on what is listed in regen.sh
	eaclocal -I src/cf
	eautoconf
	eautoconf -o configure-libafs configure-libafs.ac
	eautoheader
	einfo "Deleting autom4te.cache directory"
	rm -rf autom4te.cache
}

src_configure() {
	AFS_SYSKVERS=26 \
	econf \
		--disable-kernel-module \
		--disable-strip-binaries \
		--enable-supergroups \
		$(use_enable pam) \
		$(use_with doc html-xsl /usr/share/sgml/docbook/xsl-stylesheets/html/chunk.xsl) \
		$(use_with kerberos krb5)
}

src_compile() {
	emake all_nolibafs
	local d
	if use doc; then
		for d in doc/xml/{AdminGuide,QuickStartUnix,UserGuide}; do
			emake -C "${d}" html;
		done
	fi
}

src_install() {
	local OPENRCDIR="${WORKDIR}/gentoo/openrc"
	local SYSTEMDDIR="${WORKDIR}/gentoo/systemd"

	emake DESTDIR="${ED}" install_nolibafs

	insinto /etc/openafs
	doins src/afsd/CellServDB
	echo "/afs:/var/cache/openafs:200000" > "${ED}"/etc/openafs/cacheinfo
	echo "openafs.org" > "${ED}"/etc/openafs/ThisCell

	# pam_afs and pam_afs.krb have been installed in irregular locations, fix
	if use pam ; then
		dopammod "${ED}"/usr/$(get_libdir)/pam_afs*
	fi
	rm -f "${ED}"/usr/$(get_libdir)/pam_afs* || die

	# remove kdump stuff provided by kexec-tools #222455
	rm -rf "${ED}"/usr/sbin/kdump*

	# avoid collision with mit_krb5's version of kpasswd
	mv "${ED}"/usr/bin/kpasswd{,_afs} || die
	mv "${ED}"/usr/share/man/man1/kpasswd{,_afs}.1 || die

	# move lwp stuff around #200674 #330061
	mv "${ED}"/usr/include/{lwp,lock,timer}.h "${ED}"/usr/include/afs/ || die
	mv "${ED}"/usr/$(get_libdir)/liblwp* "${ED}"/usr/$(get_libdir)/afs/ || die
	# update paths to the relocated lwp headers
	sed -ri \
		-e '/^#include <(lwp|lock|timer).h>/s:<([^>]*)>:<afs/\1>:' \
		"${ED}"/usr/include/*.h \
		"${ED}"/usr/include/*/*.h \
		|| die

	# minimal documentation
	use pam && doman src/pam/pam_afs.5
	dodoc "${WORKDIR}/gentoo/README" src/afsd/CellServDB

	# documentation package
	if use doc ; then
		dodoc -r doc/{arch,examples,protocol,txt}
		dohtml -r doc/xml/*
	fi

	# Gentoo related scripts
	newinitd "${OPENRCDIR}"/openafs-client.initd openafs-client
	newconfd "${OPENRCDIR}"/openafs-client.confd openafs-client
	newinitd "${OPENRCDIR}"/openafs-server.initd openafs-server
	newconfd "${OPENRCDIR}"/openafs-server.confd openafs-server
	systemd_dotmpfilesd "${SYSTEMDDIR}"/tmpfiles.d/openafs-client.conf
	systemd_dounit "${SYSTEMDDIR}"/openafs-client.service
	systemd_dounit "${SYSTEMDDIR}"/openafs-server.service

	# used directories: client
	keepdir /etc/openafs
	keepdir /var/cache/openafs

	# used directories: server
	keepdir /etc/openafs/server
	diropts -m0700
	keepdir /var/lib/openafs
	keepdir /var/lib/openafs/db
	diropts -m0755
	keepdir /var/lib/openafs/logs

	# link logfiles to /var/log
	dosym ../lib/openafs/logs /var/log/openafs
}

pkg_preinst() {
	## Somewhat intelligently install default configuration files
	## (when they are not present)
	local x
	for x in cacheinfo CellServDB ThisCell ; do
		if [ -e "${EROOT}"/etc/openafs/${x} ] ; then
			cp "${EROOT}"/etc/openafs/${x} "${ED}"/etc/openafs/
		fi
	done
}

pkg_postinst() {
	elog "This installation should work out of the box (at least the"
	elog "client part doing global afs-cell browsing, unless you had"
	elog "a previous and different configuration).  If you want to"
	elog "set up your own cell or modify the standard config,"
	elog "please have a look at the Gentoo OpenAFS documentation"
	elog "(warning: it is not yet up to date wrt the new file locations)"
	elog
	elog "The documentation can be found at:"
	elog "  https://wiki.gentoo.org/wiki/OpenAFS"
}
