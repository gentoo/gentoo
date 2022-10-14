https://bugs.gentoo.org/559832

the get_client_id func is used outside of IPv6 code, so don't store it in the
IPv6-specific dhcpv6.c file.  otherwise, building w/out IPv6 & w/ldap yields:
dhcpd-ldap.o: In function 'find_client_in_ldap':
ldap.c:(.text+0x4774): undefined reference to 'get_client_id'

--- a/server/dhcpleasequery.c
+++ b/server/dhcpleasequery.c
@@ -33,6 +33,34 @@
  *       DoS'ed by DHCPLEASEQUERY message.
  */
 
+/*
+ * Get the client identifier from the packet.
+ */
+isc_result_t
+get_client_id(struct packet *packet, struct data_string *client_id) {
+	struct option_cache *oc;
+
+	/*
+	 * Verify our client_id structure is empty.
+	 */
+	if ((client_id->data != NULL) || (client_id->len != 0)) {
+		return DHCP_R_INVALIDARG;
+	}
+
+	oc = lookup_option(&dhcpv6_universe, packet->options, D6O_CLIENTID);
+	if (oc == NULL) {
+		return ISC_R_NOTFOUND;
+	}
+
+	if (!evaluate_option_cache(client_id, packet, NULL, NULL,
+				   packet->options, NULL,
+				   &global_scope, oc, MDL)) {
+		return ISC_R_FAILURE;
+	}
+
+	return ISC_R_SUCCESS;
+}
+
 /* 
  * If you query by hardware address or by client ID, then you may have
  * more than one IP address for your query argument. We need to do two
--- a/server/dhcpv6.c
+++ b/server/dhcpv6.c
@@ -392,34 +392,6 @@ generate_new_server_duid(void) {
 }
 
 /*
- * Get the client identifier from the packet.
- */
-isc_result_t
-get_client_id(struct packet *packet, struct data_string *client_id) {
-	struct option_cache *oc;
-
-	/*
-	 * Verify our client_id structure is empty.
-	 */
-	if ((client_id->data != NULL) || (client_id->len != 0)) {
-		return DHCP_R_INVALIDARG;
-	}
-
-	oc = lookup_option(&dhcpv6_universe, packet->options, D6O_CLIENTID);
-	if (oc == NULL) {
-		return ISC_R_NOTFOUND;
-	}
-
-	if (!evaluate_option_cache(client_id, packet, NULL, NULL,
-				   packet->options, NULL,
-				   &global_scope, oc, MDL)) {
-		return ISC_R_FAILURE;
-	}
-
-	return ISC_R_SUCCESS;
-}
-
-/*
  * Message validation, defined in RFC 3315, sections 15.2, 15.5, 15.7:
  *
  *    Servers MUST discard any Solicit messages that do not include a
