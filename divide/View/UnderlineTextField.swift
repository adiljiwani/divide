//
//  UnderlineTextField.swift
//  divide
//
//  Created by Adil Jiwani on 2018-06-18.
//  Copyright © 2018 Adil Jiwani. All rights reserved.
//

import UIKit
import EasyPeasy

public struct TextFieldEntryData {
    let title: String
    let placeholder: String
    
    public init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
    }
}

public class UnderlineTextField: UIView {
    private var padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()
    private let contentView = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ data: TextFieldEntryData) {
        titleLabel.text = data.title
        textField.placeholder = data.placeholder
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupTitleLabel()
        setupTextField()
        setupErrorLabel()
        
        addSubview(contentView)
        contentView.easy.layout(Left(), Right(), Height(75))
        contentView.addSubview(titleLabel)
        titleLabel.easy.layout(Left(), Top(), Right(), Height(22))
        contentView.addSubview(textField)
        textField.easy.layout(Left(), Top().to(titleLabel), Right(), Height(30))
        contentView.addSubview(errorLabel)
        errorLabel.easy.layout(Left(), Right(), Top().to(textField), Height(22), Bottom())
    }
    
    public func setStatus(_ status: ViewStatus, message: String? = nil) {
        errorLabel.isHidden = status != .error
        errorLabel.text = message
    }
    
}

extension UnderlineTextField {
    func setupTitleLabel() {
        titleLabel.font = UI.Font.medium(14)
        titleLabel.textColor = UI.Colours.white
    }
    
    func setupTextField() {
        textField.delegate = self
        textField.font = UI.Font.medium()
    }
    
    func setupErrorLabel() {
        errorLabel.textColor = UI.Colours.pink
        errorLabel.font = UI.Font.regular()
        errorLabel.isHidden = true
    }
}

extension UnderlineTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
