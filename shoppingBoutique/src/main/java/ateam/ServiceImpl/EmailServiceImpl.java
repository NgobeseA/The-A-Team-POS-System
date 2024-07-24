/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ateam.ServiceImpl;

/**
 *
 * @author Train 09
 */
import ateam.Models.Email;
import ateam.Models.Product;
import ateam.Service.EmailService;
import java.math.BigDecimal;
import java.util.List;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailServiceImpl implements EmailService {

    private Email email;

    public EmailServiceImpl(Email email) {
        this.email = email;
    }

    public EmailServiceImpl() {
        this.email = new Email("ramovhatp@gmail.com", "xaed clmt qpis ctvf");
    }

    @Override
    public void sendMail(Email email) {
        final String USERNAME = email.getSender();
        final String PASSWORD = email.getPassword();
        String receiver = email.getReceiver().trim();
        String subject = email.getSubject();
        String content = email.getMessage();

        if (!isValidEmail(receiver)) {
            System.err.println("Invalid email address: " + receiver);
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(receiver));
            message.setSubject(subject);
            message.setText(content);

            Transport.send(message);

            System.out.println("Email sent successfully to " + receiver);

        } catch (AddressException e) {
            System.err.println("Invalid email address: " + e.getMessage());
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void sendPasswordResetMail(String email, String otp) {
        final String from = "ramovhatp@gmail.com";
        final String password = "xaed clmt qpis ctvf";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");

        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
            message.setSubject("Password Reset OTP");
            message.setText("Your OTP for password reset is: " + otp);

            Transport.send(message);
            System.out.println("OTP sent successfully to " + email);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void sendSaleReceipt(String toEmail, String salespersonName, String saleTime, List<Product> items, BigDecimal totalAmount, String paymentMethod) {
        final String from = "ramovhatp@gmail.com";
        final String password = "xaed clmt qpis ctvf";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Sale Receipt");

            StringBuilder content = new StringBuilder();
            content.append("Dear Customer,\n\n")
                    .append("Thank you for your purchase!\n\n")
                    .append("Sale Details:\n")
                    .append("Salesperson: ").append(salespersonName).append("\n")
                    .append("Sale Time: ").append(saleTime).append("\n")
                    .append("Items Bought:\n");

            for (Product item : items) {
                content.append("- ").append(item.getProduct_name())
                        .append(" (SKU: ").append(item.getProduct_SKU())
                        .append(", Size: ").append(item.getSize())
                        .append(", Color: ").append(item.getColor())
                        .append("): ").append(item.getScanCount())
                        .append(" x ").append(item.getProduct_price()).append("\n");
            }

            content.append("\nTotal Amount: ").append(totalAmount).append("\n")
                    .append("Payment Method: ").append(paymentMethod).append("\n\n")
                    .append("Thank you for shopping with us!\n")
                    .append("Best regards,\n")
                    .append("Your Company Name");

            message.setText(content.toString());

            Transport.send(message);
            System.out.println("Sale receipt sent successfully to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return email.matches(emailRegex);
    }

}
