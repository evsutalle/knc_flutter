<?php

/**
 * This code was generated by
 * ___ _ _ _ _ _    _ ____    ____ ____ _    ____ ____ _  _ ____ ____ ____ ___ __   __
 *  |  | | | | |    | |  | __ |  | |__| | __ | __ |___ |\ | |___ |__/ |__|  | |  | |__/
 *  |  |_|_| | |___ | |__|    |__| |  | |    |__] |___ | \| |___ |  \ |  |  | |__| |  \
 *
 * Twilio - Wireless
 * This is the public Twilio REST API.
 *
 * NOTE: This class is auto generated by OpenAPI Generator.
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */


namespace Twilio\Rest\Wireless\V1;

use Twilio\Exceptions\TwilioException;
use Twilio\InstanceResource;
use Twilio\Options;
use Twilio\Values;
use Twilio\Version;
use Twilio\Deserialize;
use Twilio\Rest\Wireless\V1\Sim\DataSessionList;
use Twilio\Rest\Wireless\V1\Sim\UsageRecordList;


/**
 * @property string|null $sid
 * @property string|null $uniqueName
 * @property string|null $accountSid
 * @property string|null $ratePlanSid
 * @property string|null $friendlyName
 * @property string|null $iccid
 * @property string|null $eId
 * @property string $status
 * @property string $resetStatus
 * @property string|null $commandsCallbackUrl
 * @property string|null $commandsCallbackMethod
 * @property string|null $smsFallbackMethod
 * @property string|null $smsFallbackUrl
 * @property string|null $smsMethod
 * @property string|null $smsUrl
 * @property string|null $voiceFallbackMethod
 * @property string|null $voiceFallbackUrl
 * @property string|null $voiceMethod
 * @property string|null $voiceUrl
 * @property \DateTime|null $dateCreated
 * @property \DateTime|null $dateUpdated
 * @property string|null $url
 * @property array|null $links
 * @property string|null $ipAddress
 */
class SimInstance extends InstanceResource
{
    protected $_dataSessions;
    protected $_usageRecords;

    /**
     * Initialize the SimInstance
     *
     * @param Version $version Version that contains the resource
     * @param mixed[] $payload The response payload
     * @param string $sid The SID or the `unique_name` of the Sim resource to delete.
     */
    public function __construct(Version $version, array $payload, string $sid = null)
    {
        parent::__construct($version);

        // Marshaled Properties
        $this->properties = [
            'sid' => Values::array_get($payload, 'sid'),
            'uniqueName' => Values::array_get($payload, 'unique_name'),
            'accountSid' => Values::array_get($payload, 'account_sid'),
            'ratePlanSid' => Values::array_get($payload, 'rate_plan_sid'),
            'friendlyName' => Values::array_get($payload, 'friendly_name'),
            'iccid' => Values::array_get($payload, 'iccid'),
            'eId' => Values::array_get($payload, 'e_id'),
            'status' => Values::array_get($payload, 'status'),
            'resetStatus' => Values::array_get($payload, 'reset_status'),
            'commandsCallbackUrl' => Values::array_get($payload, 'commands_callback_url'),
            'commandsCallbackMethod' => Values::array_get($payload, 'commands_callback_method'),
            'smsFallbackMethod' => Values::array_get($payload, 'sms_fallback_method'),
            'smsFallbackUrl' => Values::array_get($payload, 'sms_fallback_url'),
            'smsMethod' => Values::array_get($payload, 'sms_method'),
            'smsUrl' => Values::array_get($payload, 'sms_url'),
            'voiceFallbackMethod' => Values::array_get($payload, 'voice_fallback_method'),
            'voiceFallbackUrl' => Values::array_get($payload, 'voice_fallback_url'),
            'voiceMethod' => Values::array_get($payload, 'voice_method'),
            'voiceUrl' => Values::array_get($payload, 'voice_url'),
            'dateCreated' => Deserialize::dateTime(Values::array_get($payload, 'date_created')),
            'dateUpdated' => Deserialize::dateTime(Values::array_get($payload, 'date_updated')),
            'url' => Values::array_get($payload, 'url'),
            'links' => Values::array_get($payload, 'links'),
            'ipAddress' => Values::array_get($payload, 'ip_address'),
        ];

        $this->solution = ['sid' => $sid ?: $this->properties['sid'], ];
    }

    /**
     * Generate an instance context for the instance, the context is capable of
     * performing various actions.  All instance actions are proxied to the context
     *
     * @return SimContext Context for this SimInstance
     */
    protected function proxy(): SimContext
    {
        if (!$this->context) {
            $this->context = new SimContext(
                $this->version,
                $this->solution['sid']
            );
        }

        return $this->context;
    }

    /**
     * Delete the SimInstance
     *
     * @return bool True if delete succeeds, false otherwise
     * @throws TwilioException When an HTTP error occurs.
     */
    public function delete(): bool
    {

        return $this->proxy()->delete();
    }

    /**
     * Fetch the SimInstance
     *
     * @return SimInstance Fetched SimInstance
     * @throws TwilioException When an HTTP error occurs.
     */
    public function fetch(): SimInstance
    {

        return $this->proxy()->fetch();
    }

    /**
     * Update the SimInstance
     *
     * @param array|Options $options Optional Arguments
     * @return SimInstance Updated SimInstance
     * @throws TwilioException When an HTTP error occurs.
     */
    public function update(array $options = []): SimInstance
    {

        return $this->proxy()->update($options);
    }

    /**
     * Access the dataSessions
     */
    protected function getDataSessions(): DataSessionList
    {
        return $this->proxy()->dataSessions;
    }

    /**
     * Access the usageRecords
     */
    protected function getUsageRecords(): UsageRecordList
    {
        return $this->proxy()->usageRecords;
    }

    /**
     * Magic getter to access properties
     *
     * @param string $name Property to access
     * @return mixed The requested property
     * @throws TwilioException For unknown properties
     */
    public function __get(string $name)
    {
        if (\array_key_exists($name, $this->properties)) {
            return $this->properties[$name];
        }

        if (\property_exists($this, '_' . $name)) {
            $method = 'get' . \ucfirst($name);
            return $this->$method();
        }

        throw new TwilioException('Unknown property: ' . $name);
    }

    /**
     * Provide a friendly representation
     *
     * @return string Machine friendly representation
     */
    public function __toString(): string
    {
        $context = [];
        foreach ($this->solution as $key => $value) {
            $context[] = "$key=$value";
        }
        return '[Twilio.Wireless.V1.SimInstance ' . \implode(' ', $context) . ']';
    }
}

