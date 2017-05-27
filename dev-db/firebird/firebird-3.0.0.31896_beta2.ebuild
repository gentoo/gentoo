# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/firebird/firebird-2.5.3.26780.0-r1.ebuild,v 1.2 2015/03/21 14:57:55 jlec Exp $

EAPI=5

inherit flag-o-matic eutils autotools multilib user readme.gentoo versionator

MY_P=${PN/f/F}-$(replace_version_separator 4 -)
MY_P=${MY_P/beta/Beta}

DESCRIPTION="A relational database offering many ANSI SQL:2003 and some SQL:2008 features"
HOMEPAGE="http://www.firebirdsql.org/"
SRC_URI="
	mirror://sourceforge/${PN}/${PN}/3.0-Beta_2/${MY_P}.tar.bz2
	 doc? (	ftp://ftpc.inprise.com/pub/interbase/techpubs/ib_b60_doc.zip )"

LICENSE="IDPL Interbase-1.0"
SLOT="0"
KEYWORDS="~amd64 -ia64 ~x86"

IUSE="doc client xinetd examples debug"
REQUIRED_USE="
	client? ( !xinetd )
"

CDEPEND="
	dev-libs/libedit
	dev-libs/libtommath
	dev-libs/icu:=
"
DEPEND="${CDEPEND}
	>=dev-util/btyacc-3.0-r2
	doc? ( app-arch/unzip )
"
RDEPEND="${CDEPEND}
	xinetd? ( virtual/inetd )
	!sys-cluster/ganglia
"

RESTRICT="userpriv"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup firebird 450
	enewuser firebird 450 /bin/bash /usr/$(get_libdir)/firebird firebird
}

function check_sed() {
	MSG="sed of $3, required $2 lines modified $1"
	einfo "${MSG}"
	[[ $1 -ge $2 ]] || die "${MSG}"
}

src_unpack() {
	unpack "${MY_P}.tar.bz2"
	if use doc; then
		# Unpack docs
		mkdir "${WORKDIR}/manuals" && cd "${WORKDIR}/manuals" || die
		unpack ib_b60_doc.zip
	fi
}


src_prepare() {
	# This patch might be portable, and not need to be duplicated per version
	# also might no longer be necessary to patch deps or libs, just flags
	epatch "${FILESDIR}"/${P}-deps-flags.patch

#	use client && epatch "${FILESDIR}"/${PN}-2.5.1.26351.0-client.patch

	# Rename references to isql to fbsql
	# sed vs patch for portability and addtional location changes
	check_sed "$(sed -i -e 's:"isql :"fbsql :w /dev/stdout' \
		src/isql/isql.epp | wc -l)" "1" "src/isql/isql.epp" # 1 line
	check_sed "$(sed -i -e 's:isql :fbsql :w /dev/stdout' \
		src/msgs/history2.sql | wc -l)" "4" "src/msgs/history2.sql" # 4 lines
	check_sed "$(sed -i -e 's:--- ISQL:--- FBSQL:w /dev/stdout' \
		-e 's:isql :fbsql :w /dev/stdout' \
		-e 's:ISQL :FBSQL :w /dev/stdout' \
		src/msgs/messages2.sql | wc -l)" "6" "src/msgs/messages2.sql" # 6 lines

	# doing for all archs not just keyworded
	sed -i -e 's|-ggdb ||g' \
		-e 's|-pipe ||g' \
		-e 's|$(COMMON_FLAGS) $(OPTIMIZE_FLAGS)|$(COMMON_FLAGS)|g' \
		builds/posix/prefix.linux* || die

	sed -i -e "s|\$(this)|/usr/$(get_libdir)/firebird/intl|g" \
		builds/install/misc/fbintl.conf

	sed -i -e "s|\$(this)|/usr/$(get_libdir)/firebird/plugins|g" \
		src/plugins/udr_engine/udr_engine.conf

	find "${S}" -name \*.sh -print0 | xargs -0 chmod +x || die
	rm -rf "${S}"/extern/

	eautoreconf
}

src_configure() {
	filter-flags -fprefetch-loop-arrays
	filter-mfpmath sse

	econf \
		--prefix=/usr/$(get_libdir)/firebird \
		--with-editline \
		--with-system-editline \
		--with-fbbin=/usr/bin \
		--with-fbsbin=/usr/sbin \
		--with-fbconf=/etc/${PN} \
		--with-fblib=/usr/$(get_libdir) \
		--with-fbinclude=/usr/include \
		--with-fbdoc=/usr/share/doc/${P} \
		--with-fbudf=/usr/$(get_libdir)/${PN}/UDF \
		--with-fbsample=/usr/share/doc/${P}/examples \
		--with-fbsample-db=/usr/share/doc/${P}/examples/db \
		--with-fbhelp=/usr/$(get_libdir)/${PN}/help \
		--with-fbintl=/usr/$(get_libdir)/${PN}/intl \
		--with-fbmisc=/usr/share/${PN} \
		--with-fbsecure-db=/etc/${PN} \
		--with-fbmsg=/usr/$(get_libdir)/${PN} \
		--with-fblog=/var/log/${PN}/ \
		--with-fbglock=/var/run/${PN} \
		--with-fbplugins=/usr/$(get_libdir)/${PN}/plugins \
		--with-gnu-ld \
		${myconf}
}

src_install() {
	cd ${S}/gen/Release/${PN} || die

	if use doc; then
		dodoc "${S}"/doc/*.pdf
		find "${WORKDIR}"/manuals -type f -iname "*.pdf" -exec dodoc '{}' + || die
	fi

	doheader include/*

	insinto /usr/$(get_libdir)
	dolib.so lib/*.so*

	# links for backwards compatibility
	dosym libfbclient.so /usr/$(get_libdir)/libgds.so
	dosym libfbclient.so /usr/$(get_libdir)/libgds.so.0
	dosym libfbclient.so /usr/$(get_libdir)/libfbclient.so.1

	insinto /usr/$(get_libdir)/${PN}
	doins *.msg

	use client && return

	# if statement for ebuild install testing
	einfo "Renaming isql -> fbsql"
	[[ -e bin/isql ]] && mv bin/isql bin/fbsql

	local bins="fbsql fbsvcmgr fbtracemgr gbak gfix gpre gsec gsplit gstat nbackup qli"
	for bin in ${bins[@]}; do
		dobin bin/${bin}
	done

	local sbins="fbguard fb_lock_print firebird"
	for sbin in ${sbins[@]}; do
		dosbin bin/${sbin}
	done

#	Temp should not be necessary, need to patch/fix
#	dosym "${D}"/usr/$(get_libdir)/libib_util.so /usr/$(get_libdir)/${PN}/lib/libib_util.so

	exeinto /usr/bin/${PN}
	exeopts -m0755
	doexe bin/{changeServerMode,registerDatabase}.sh

	insinto /usr/$(get_libdir)/${PN}/help
	doins help/help.fdb

	exeinto /usr/$(get_libdir)/firebird/intl
	dolib.so intl/libfbintl.so
	dosym "${D}"/usr/$(get_libdir)/libfbintl.so /usr/$(get_libdir)/${PN}/intl/fbintl
	dosym "${D}"/etc/${PN}/fbintl.conf /usr/$(get_libdir)/${PN}/intl/fbintl.conf

	exeinto /usr/$(get_libdir)/${PN}/plugins
	local plugins="libEngine12.so libLegacy_Auth.so libLegacy_UserManager.so libSrp.so libudr_engine.so"
	for plugin in ${plugins[@]}; do
		dolib.so plugins/${plugin}
		dosym "${D}"/usr/$(get_libdir)/${plugin} \
			/usr/$(get_libdir)/${PN}/plugins/${plugin}
	done
	dodir udr
	dosym "${D}"/etc/${PN}/udr_engine.conf /usr/$(get_libdir)/${PN}/plugins/udr_engine.conf

	exeinto /usr/$(get_libdir)/${PN}/UDF
	doexe UDF/*.so

	insinto /usr/share/${PN}/upgrade
	doins "${S}"/src/misc/upgrade/*

	insinto /etc/${PN}
	insopts -m0644 -o firebird -g firebird
	doins *.conf
	doins intl/fbintl.conf
	doins plugins/udr_engine.conf
	insopts -m0660 -o firebird -g firebird
	doins security3.fdb

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/${PN}.xinetd" ${PN}
	else
		newinitd "${FILESDIR}/${PN}.init.d" ${PN}
		newconfd "${FILESDIR}/${PN}.conf.d" ${PN}
		fperms 640 /etc/conf.d/${PN}
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}
	fperms 0644 /etc/logrotate.d/${PN}

	diropts -m 755 -o firebird -g firebird
	keepdir /var/log/${PN}
	keepdir /var/run/${PN}

	use examples && docinto examples
}

pkg_postinst() {
	use client && return

	# Hack to fix ownership/perms
	chown -fR firebird:firebird "${ROOT}/etc/${PN}" "${ROOT}/usr/$(get_libdir)/${PN}"
	chmod 750 "${ROOT}/etc/${PN}"
}

pkg_config() {
	use client && return

	# if found /etc/security2.gdb from previous install, backup, and restore as
	# /etc/security3.fdb
	if [ -f "${ROOT}/etc/firebird/security2.gdb" ] ; then
		# if we have scurity2.fdb already, back it 1st
		if [ -f "${ROOT}/etc/firebird/security3.fdb" ] ; then
			cp "${ROOT}/etc/firebird/security3.fdb" "${ROOT}/etc/firebird/security3.fdb.old"
		fi
		gbak -B "${ROOT}/etc/firebird/security2.gdb" "${ROOT}/etc/firebird/security2.gbk"
		gbak -R "${ROOT}/etc/firebird/security2.gbk" "${ROOT}/etc/firebird/security3.fdb"
		mv "${ROOT}/etc/firebird/security2.gdb" "${ROOT}/etc/firebird/security2.gdb.old"
		rm "${ROOT}/etc/firebird/security2.gbk"

		# make sure they are readable only to firebird
		chown firebird:firebird "${ROOT}/etc/firebird/{security2.*,security3.*}"
		chmod 660 "${ROOT}/etc/firebird/{security2.*,security3.*}"

		echo
		einfo "Converted old security2.gdb to security3.fdb, security2.gdb has been "
		einfo "renamed to security2.gdb.old. if you had previous security3.fdb, "
		einfo "it's backed to security3.fdb.old (all under ${ROOT}/etc/firebird)."
		echo
	fi

	# we need to enable local access to the server
	if [ ! -f "${ROOT}/etc/hosts.equiv" ] ; then
		touch "${ROOT}/etc/hosts.equiv"
		chown root:0 "${ROOT}/etc/hosts.equiv"
		chmod u=rw,go=r "${ROOT}/etc/hosts.equiv"
	fi

	# add 'localhost.localdomain' to the hosts.equiv file...
	if [ grep -q 'localhost.localdomain$' "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "localhost.localdomain" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added localhost.localdomain to ${ROOT}/etc/hosts.equiv"
	fi

	# add 'localhost' to the hosts.equiv file...
	if [ grep -q 'localhost$' "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "localhost" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added localhost to ${ROOT}/etc/hosts.equiv"
	fi

	HS_NAME=`hostname`
	if [ grep -q ${HS_NAME} "${ROOT}/etc/hosts.equiv" 2>/dev/null ] ; then
		echo "${HS_NAME}" >> "${ROOT}/etc/hosts.equiv"
		einfo "Added ${HS_NAME} to ${ROOT}/etc/hosts.equiv"
	fi

	einfo "If you're using UDFs, please remember to move them"
	einfo "to /usr/lib/firebird/UDF"
}
